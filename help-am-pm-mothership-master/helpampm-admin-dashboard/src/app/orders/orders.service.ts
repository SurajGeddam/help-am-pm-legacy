import { Injectable } from '@angular/core';
import { HttpService } from '../core/service/http.service';

@Injectable({
  providedIn: 'root'
})
export class OrdersService {

  constructor(private http: HttpService) { }

  getHistoryOrders(pageParams) {
    return this.http.post('quote/pageable-orders/history', pageParams)
  }
  getRunningOrders(pageParams) {
    return this.http.post('quote/pageable-orders/started', pageParams)
  }
  getScheduledOrders(pageParams) {
    return this.http.post('quote/pageable-orders/scheduled', pageParams)
  }
  getOrderData(quoteUniqueId){
    return this.http.get("quote/web/"+quoteUniqueId);
  }
}
