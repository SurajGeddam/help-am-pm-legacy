import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { OrdersService } from '../orders.service';


@Component({
  selector: 'app-order-details',
  templateUrl: './order-details.component.html',
  styleUrls: ['./order-details.component.sass']
})
export class OrderDetailsComponent {

  orderDetail: any;
  constructor(@Inject(MAT_DIALOG_DATA) public data: any, private ordersService : OrdersService) {
    this.orderDetail = data;
  }
  ngOnInit(){
    this.ordersService.getOrderData(this.orderDetail.quoteUniqueId).subscribe(
      resp => {
        this.orderDetail = resp;
      }
    )
  }
}
