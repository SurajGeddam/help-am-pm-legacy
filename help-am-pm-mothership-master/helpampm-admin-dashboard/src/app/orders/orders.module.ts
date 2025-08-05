import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { NgxDatatableModule } from '@swimlane/ngx-datatable';
import { OrderRoutingModule } from './orders-routing.module';
import { OrdersService } from './orders.service';
import { HistoryOrdersComponent } from './history-orders/history-orders.component';
import { RunningOrdersComponent } from './running-orders/running-orders.component';
import { ScheduledOrdersComponent } from './scheduled-orders/scheduled-orders.component';

import { SharedModule } from '../shared/shared.module';
import { OrderDetailsComponent } from './order-details/order-details.component';

@NgModule({
  declarations: [
    HistoryOrdersComponent,
    RunningOrdersComponent,
    ScheduledOrdersComponent,
    OrderDetailsComponent
  ],
  imports: [
    CommonModule,
    OrderRoutingModule,
    NgxDatatableModule,
    SharedModule,
  ],
  providers: [OrdersService]
})
export class OrdersModule { }

