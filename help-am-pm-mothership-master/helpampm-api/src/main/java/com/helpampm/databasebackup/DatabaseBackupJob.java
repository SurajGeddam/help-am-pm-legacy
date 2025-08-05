/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.databasebackup;

import com.helpampm.common.services.FileService;
import com.zaxxer.hikari.HikariDataSource;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteWatchdog;
import org.apache.commons.exec.PumpStreamHandler;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.concurrent.TimeUnit;

/**
 * @author kuldeep
 */
@SuppressFBWarnings("EI_EXPOSE_REP2")
@Component
@RequiredArgsConstructor
@Slf4j
public class DatabaseBackupJob {
    private final HikariDataSource hikariDataSource;
    private final FileService fileService;
    @Value("${help.database_backup.location}")
    private String databaseBackupLocation;

    //@Scheduled(cron = "0 0 0 * * ?") //Mid night
   // @Scheduled(cron = "0 */2 * * * *")
    public void performBackup() {
        try {
            String path = runDatabaseBackup();

            if (path != null) {
                fileService.uploadDatabaseBackupFileToS3(new File(path));
                log.info("Database backup completed");
                // deleteLocalFile(new File(path));
                log.info("Local database backup file deleted");
            }
        } catch (Throwable th) {
            th.printStackTrace();
            log.warn("Database backup failed: " + th.getMessage());
        }
    }

    private void deleteLocalFile(File file) {
        if (file.exists()) {
            //file.delete();
        }
    }

    @SuppressFBWarnings("ODR_OPEN_DATABASE_RESOURCE")
    private String runDatabaseBackup() throws IOException {
        String database = null;
        // Execute SQL to get the name of the current database
        try (Connection connection = hikariDataSource.getConnection()) {
            try (ResultSet resultSet = connection.createStatement().executeQuery("SELECT DATABASE();")) {
                if (resultSet.next()) {
                    database = resultSet.getString(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        // stdErr
        ByteArrayOutputStream stdErr = new ByteArrayOutputStream();
        File dir = new File(databaseBackupLocation);
        if (!dir.exists()) {
            if(!dir.mkdir()) {
                throw new RuntimeException("Unable to create database backup directory");
            }
        }
        Path sqlFile = Paths.get(databaseBackupLocation + "/" + database + "_" + LocalDateTime.now().toEpochSecond(ZoneOffset.ofTotalSeconds(0)) + ".sql");
        // stdOut
        OutputStream stdOut;
        try {
            stdOut = new BufferedOutputStream(Files.newOutputStream(sqlFile, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try (stdErr; stdOut) {
            ExecuteWatchdog watchdog = new ExecuteWatchdog(TimeUnit.HOURS.toMillis(1));
            DefaultExecutor defaultExecutor = new DefaultExecutor();
            defaultExecutor.setWatchdog(watchdog);
            defaultExecutor.setStreamHandler(new PumpStreamHandler(stdOut, stdErr));

            //docker exec helpampm-api-mysqldb-1 /usr/bin/mysqldump -u root --password=Admin@123  helpampmdb> /home/ec2-user/helpampm_database_backup/backup.sql

            CommandLine commandLine = new CommandLine("docker exec helpampm-api-mysqldb-1 /usr/bin/mysqldump");
            commandLine.addArgument("-u " + hikariDataSource.getUsername());
            commandLine.addArgument("--password " + hikariDataSource.getPassword());
            log.info("sqlfile path --> {}", sqlFile);
            commandLine.addArgument("helpampmdb> " + sqlFile);
            //commandLine.addArgument(database); // database
            log.info("command -> {}", commandLine);


            log.info("Exporting SQL data...");
            // Synchronous execution. Blocking until the execution of the child process is complete.
            int exitCode = defaultExecutor.execute(commandLine);

            if (defaultExecutor.isFailure(exitCode) && watchdog.killedProcess()) {
                log.error("timeout...");
            }
            log.info("SQL data export completed: exitCode={}, sqlFile={}", exitCode, sqlFile);

        } catch (Exception e) {
            log.error("SQL data export exception: {}", e.getMessage());
            log.error("std err: {}{}", System.lineSeparator(), stdErr);
            return null;
        }
        return sqlFile.toString();
    }
}
