package com.helpampm.auth.services;

import com.helpampm.metadata.category.Category;
import com.helpampm.metadata.category.CategoryService;
import com.helpampm.metadata.timeslot.Timeslot;
import com.helpampm.quote.QuoteServiceImpl;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalTime;
import java.util.Optional;

@SpringBootTest
class CategoryTest {

    @Autowired
    QuoteServiceImpl quoteServiceIml;

    @Autowired
    CategoryService categoryService;

    @Test
    void testQuoteTimeslot() {
        Optional<Category> category = categoryService.findByName("HVAC");

        LocalTime time = LocalTime.of(8, 40, 0);
        Timeslot timeslot = quoteServiceIml.getTimeslot(category, time);
        Assertions.assertEquals("Morning Hours", timeslot.getName());


        LocalTime time1 = LocalTime.of(10, 40, 0);
        Timeslot timeslot1 = quoteServiceIml.getTimeslot(category, time1);
        Assertions.assertEquals("Regular Hours", timeslot1.getName());

        LocalTime time2 = LocalTime.of(18, 40, 0);
        Timeslot timeslot2 = quoteServiceIml.getTimeslot(category, time2);
        Assertions.assertEquals("Late Hours", timeslot2.getName());

        LocalTime time3 = LocalTime.of(21, 40, 0);
        Timeslot timeslot3 = quoteServiceIml.getTimeslot(category, time3);
        Assertions.assertEquals("Night Hours", timeslot3.getName());

        LocalTime time4 = LocalTime.of(6, 40, 0);
        Timeslot timeslot4 = quoteServiceIml.getTimeslot(category, time4);
        Assertions.assertEquals("Night Hours", timeslot4.getName());


        LocalTime time5 = LocalTime.of(17, 0, 0);
        Timeslot timeslot5 = quoteServiceIml.getTimeslot(category, time5);
        Assertions.assertEquals("Late Hours", timeslot5.getName());

        LocalTime time6 = LocalTime.of(14, 0, 0);
        Timeslot timeslot6 = quoteServiceIml.getTimeslot(category, time6);
        Assertions.assertEquals("Afternoon Hours", timeslot6.getName());

        LocalTime time7 = LocalTime.of(9, 0, 0);
        Timeslot timeslot7 = quoteServiceIml.getTimeslot(category, time7);
        Assertions.assertEquals("Regular Hours", timeslot7.getName());

        LocalTime time8 = LocalTime.of(21, 0, 0);
        Timeslot timeslot8 = quoteServiceIml.getTimeslot(category, time8);
        Assertions.assertEquals("Night Hours", timeslot8.getName());

    }


}