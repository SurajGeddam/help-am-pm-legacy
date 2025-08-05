import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { HttpService } from '../core/service/http.service';
import { UnsubscribeOnDestroyAdapter } from '../shared/UnsubscribeOnDestroyAdapter';
@Injectable()
export class CustomersService extends UnsubscribeOnDestroyAdapter {
  isTblLoading = true;
  dataChange: BehaviorSubject<any[]> = new BehaviorSubject<any[]>([]);

  // Temporarily stores data from dialogs
  dialogData: any;
  constructor(private httpClient: HttpService) {
    super();
  }
  
  /** CRUD METHODS */
  getAllCustomers(pageParams) {
    return this.httpClient.post("customer/pageableCustomer",pageParams);
  }
  activeInactiveCustomers(data) {
    return this.httpClient.put("customer/profile",data);
  }
}
