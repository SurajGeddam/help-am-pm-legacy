import { HttpClient } from '@angular/common/http';
import { Component, OnInit, ViewChild } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { DatatableComponent } from '@swimlane/ngx-datatable';
import { MessageService } from '../core/service/message.service';
import { ConfirmDialogComponent, ConfirmDialogModel } from '../shared/components/confirm-dialog/confirm-dialog.component';
import { ProvidersService } from './providers.service';
import { ViewProviderComponent } from './view-provider/view-provider.component';

@Component({
  selector: 'app-providers',
  templateUrl: './providers.component.html',
  styleUrls: ['./providers.component.sass']
})
export class ProvidersComponent implements OnInit {

  @ViewChild(DatatableComponent, { static: false }) table: DatatableComponent;

  rows = [];
  data = [];
  filteredData = [];
  isEdit: boolean = false;
  page: any = {
    count: 0, // total count of items
    offset: 0, // Page number
    limit: 5, // number of items per page
    orderColumn: 'createdAt',
    orderDir: 'DESC'

  };
  lastSearchText = '';
  currentSearchText = ''
  categoryId: number;

  constructor(
    // public httpClient: HttpService,
    public viewProviderDialog: MatDialog,
    public dialog: MatDialog,
    public messageService: MessageService,
    public providerService: ProvidersService,
  ) {
    // super();
  }

  ngOnInit() {
    this.loadData(this.getPageParams());
  }
  refresh() {
    this.loadData(this.getPageParams());
  }

  public loadData(pageParams) {
    this.providerService.getAllProviders(pageParams).subscribe(
      (res: any) => {
        this.data = res.providers;
        this.page.count = res.count;
        this.filteredData = this.data;
      }
    )
  }

  pageCallback(pageInfo: { count?: number, pageSize?: number, limit?: number, offset?: number }) {
    this.page.offset = pageInfo.offset;
    this.refresh();
  }

  changePageSize(pageInfo: { count?: number, pageSize?: number, limit?: number, offset?: number }) {
    this.page.offset = pageInfo.offset;
    this.refresh();
  }

  getPageParams() {
    let pageParams = {
      'orderColumn': 'createdAt',
      'orderDir': this.page.orderDir,
      'pageNumber': this.page.offset,
      'pageSize': this.page.limit,
    }
    if (this.lastSearchText.length > 2 || this.lastSearchText.length == 0) {
      pageParams["searchText"] = this.lastSearchText;
    }
    return pageParams;

  }

  searchCallback(event) {

    this.currentSearchText = event.target.value;
    if (this.lastSearchText !== this.currentSearchText) {
      this.lastSearchText = this.currentSearchText;
      if (this.currentSearchText.length > 2 || this.currentSearchText.length == 0) {
        this.page.offset = 0;
        var pageParams = this.getPageParams();
        this.loadData(pageParams);
      }
    }
  }


  changeStatus(event, row) {
    let message = '';
    if (event.checked) {
      message = "Are you sure you want to Enable this provider?"
    } else {
      message = "Are you sure you want to Disable this provider?";
    }
    const dialogData = new ConfirmDialogModel("Confirm Action", message);
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      maxWidth: "400px",
      data: dialogData
    });

    dialogRef.afterClosed().subscribe(dialogResult => {
      if (dialogResult) {
        let provider = row;
        provider = {
          id: row.id,
          isActive: event.checked
        }
        this.providerService.activeInactiveProviders(provider).subscribe((res: any) => {
          var data: any;
          data = res;
          if (data.isActive) {
            this.messageService.showSuccess("Provider " + data.name + " Enabled successfully")
          } else {
            this.messageService.showSuccess("Provider " + data.name + "  Disabled successfully")
          }
        });
      }
    });
  }

  viewProvider(event) {
    this.viewProviderDialog.open(ViewProviderComponent, {
      width: '60%',
      height: '80%',
      data: event
    });
  }

  sendAccountCompleteRemider(providerUniqueId) {

    //console.log("Send Account setup reminder => " + providerUniqueId);
    this.providerService.sendAccountCompleteReminder(providerUniqueId).subscribe(res => {
      const dialogData = new ConfirmDialogModel("Mail Sent", "Are you sure you want to Delete Tax?");
      
      this.messageService.showSuccess('Reminder mail sent Successfully');
    })
  }


  getIconColor(row) {
    if (row) {
      return "green"
    } else {
      return "red"
    }
  }

  getClassColor(row) {
    if (row) {
      return "fas fa-check-circle"
    } else {
      return " icon-close"
    }
  }
}
