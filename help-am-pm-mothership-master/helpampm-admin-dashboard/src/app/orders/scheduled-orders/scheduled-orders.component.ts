import { HttpClient } from '@angular/common/http';
import { Component, OnInit, ViewChild } from '@angular/core';
import { DatatableComponent } from '@swimlane/ngx-datatable';
import { firstValueFrom } from 'rxjs';
import { ConstantService } from 'src/app/core/service/constant.service';
import { ProfileService } from 'src/app/profile/profile.service';
import { UnsubscribeOnDestroyAdapter } from 'src/app/shared/UnsubscribeOnDestroyAdapter';
import { MatDialog } from '@angular/material/dialog';
import { OrdersService } from '../orders.service';
import { OrderDetailsComponent } from '../order-details/order-details.component';


@Component({
  selector: 'app-scheduled-orders',
  templateUrl: './scheduled-orders.component.html',
  styleUrls: ['./scheduled-orders.component.sass']
})
export class ScheduledOrdersComponent extends UnsubscribeOnDestroyAdapter implements OnInit {
  @ViewChild(DatatableComponent, { static: false }) table: DatatableComponent;

  rows = [];
  data = [];
  filteredData = [];
  isEdit: boolean = false;
  page: any = {
    count: 0, // total count of items
    offset: 0, // Page number
    limit: 10, // number of items per page
    orderColumn: 'createdAt',
    orderDir: 'DESC'

  };
  lastSearchText = '';
  currentSearchText = ''
  categoryId: number;
  currentOrderDetails: any;
  orderDetailsComponent:any;

  constructor(public httpClient: HttpClient,
    public orderService: OrdersService,
    private profileService: ProfileService,
    private constantService: ConstantService,
    private modalDialog: MatDialog,
  
  ) {
    super();
  }
  showOrderDetails(currentOrderDetails) {
    this.modalDialog.open(OrderDetailsComponent, {
      width: '55%',
      height: '65%',
      data: currentOrderDetails
    });
    
  }

  async ngOnInit(): Promise<any> {
    const data = await firstValueFrom(this.profileService.getUser());
    this.currentOrderDetails = data;
    this.loadData(this.getPageParams());
  }

  refresh() {
    this.loadData(this.getPageParams());
  }

  public loadData(pageParams) {
    this.orderService.getScheduledOrders(pageParams).subscribe(
      (res: any) => {
        this.data = res.quotes;
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
      'providerUniqueId': this.currentOrderDetails.providerUniqueId
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
  setStyle(status) {
    return this.constantService.getOrderStatusColorCode(status);
  }
}
