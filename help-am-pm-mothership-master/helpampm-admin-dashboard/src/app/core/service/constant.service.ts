import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { catchError, map, Observable, throwError } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ConstantService {
  constructor(){

  }
  getOrderStatusColorCode(status) {
    if (status == 'SCHEDULED') {
      return 'label bg-orange shadow-style';
    }
    if (status == 'PAYMENT_PENDING') {
      return 'label bg-yellow shadow-style';
    }
    if (status == 'ACCEPTED_BY_PROVIDER') {
      return 'label bg-blue shadow-style';
    }
    if (status == 'STARTED') {
      return 'label bg-orange shadow-style';
    }
    if (status == 'PAYMENT_DONE') {
      return 'label bg-green shadow-style';
    }
    if (status == 'ORDER_CANCELLED') {
      return 'label bg-red shadow-style';
    }
  }
}
