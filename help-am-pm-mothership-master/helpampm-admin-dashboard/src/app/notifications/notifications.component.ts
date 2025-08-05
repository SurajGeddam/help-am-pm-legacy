import { HttpClient } from '@angular/common/http';
import { Component, OnInit, ViewChild } from '@angular/core';
import { MAT_DATE_LOCALE } from '@angular/material/core';
import { MatDialog } from '@angular/material/dialog';
import { DatatableComponent } from '@swimlane/ngx-datatable';
import { MessageService } from '../core/service/message.service';
import { interval } from 'rxjs';
import { UnsubscribeOnDestroyAdapter } from '../shared/UnsubscribeOnDestroyAdapter';
import { NotificationsService } from './notifications.service';

@Component({
  selector: 'app-notifications',
  templateUrl: './notifications.component.html',
  styleUrls: ['./notifications.component.sass'],
  providers: [{ provide: MAT_DATE_LOCALE, useValue: 'en-GB' }]
})
export class NotificationsComponent
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
    public notificationsService: NotificationsService,
  ) {
    super();
  }

  ngOnInit() {
    this.loadData(this.getPageParams());

    const sub = interval(10000).subscribe((val) => 
    {
      this.refresh();
    });
  }
  refresh() {
    this.loadData(this.getPageParams());
  }

  public loadData(pageParams) {
    this.notificationsService.getAllNotifications(pageParams).subscribe(
      (res: any) => {
        this.data = res.notifications;
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

}