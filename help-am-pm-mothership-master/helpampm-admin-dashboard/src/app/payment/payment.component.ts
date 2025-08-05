import { Component, OnInit } from '@angular/core';
import { HttpService } from '../core/service/http.service';
import { FilterService } from 'src/app/core/service/filter.service';

@Component({
  selector: 'app-payment',
  templateUrl: './payment.component.html',
  styleUrls: ['./payment.component.sass']
})
export class PaymentComponent implements OnInit {

  constructor(private http: HttpService,
    private filterService: FilterService) { }
    
  payments = [];
  filteredData=[];
  
  ngOnInit(): void {
    this.http.get('payment').subscribe(
      (res: any) => {
        this.payments = res;
        this.filteredData = this.payments;
      }
    )

    }
    /**
   * @method filterDatatable
   * @param event 
   * @description search for the filter data table
   */
    filterDatatable(event) {
      this.payments = this.filterService.filter(event, this.filteredData, this.payments);
     
    }
      


}
