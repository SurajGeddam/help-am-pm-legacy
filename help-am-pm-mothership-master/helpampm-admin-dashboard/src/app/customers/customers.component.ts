import { HttpClient } from '@angular/common/http';
import { Component, OnInit, ViewChild } from '@angular/core';
import { MAT_DATE_LOCALE } from '@angular/material/core';
import { MatDialog } from '@angular/material/dialog';
import { DatatableComponent } from '@swimlane/ngx-datatable';
import { MessageService } from '../core/service/message.service';
import { ConfirmDialogComponent, ConfirmDialogModel } from '../shared/components/confirm-dialog/confirm-dialog.component';
import { UnsubscribeOnDestroyAdapter } from '../shared/UnsubscribeOnDestroyAdapter';
import { CustomersService } from './customers.service';

@Component({
  selector: 'app-customers',
  templateUrl: './customers.component.html',
  styleUrls: ['./customers.component.sass'],
  providers: [{ provide: MAT_DATE_LOCALE, useValue: 'en-GB' }]
})
export class CustomersComponent
  extends UnsubscribeOnDestroyAdapter
  implements OnInit {
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
    public httpClient: HttpClient,
    public dialog: MatDialog,
    public messageService: MessageService,
    public customersService: CustomersService,
  ) {
    super();
  }

  ngOnInit() {
    this.loadData(this.getPageParams());
  }
  refresh() {
    this.loadData(this.getPageParams());
  }

  public loadData(pageParams) {
    this.customersService.getAllCustomers(pageParams).subscribe(
      (res: any) => {
        this.data = res.customers;
        this.page.count=res.count;
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
      message = "Are you sure you want to Enable this customer?"
    } else {
      message = "Are you sure you want to Disable this customer?";
    }
    const dialogData = new ConfirmDialogModel("Confirm Action", message);
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      maxWidth: "400px",
      data: dialogData
    });
    
    dialogRef.afterClosed().subscribe(dialogResult => {
      if (dialogResult) {
        let customer = row;
        customer = {
          id: row.id,
          isActive: event.checked,
          customerUniqueId: customer.customerUniqueId
        }
        this.customersService.activeInactiveCustomers(customer).subscribe((res: any) => {
          var data: any;
          data = res;
          this.messageService.showSuccess(data.message)
        });
      }
    });
  }

}