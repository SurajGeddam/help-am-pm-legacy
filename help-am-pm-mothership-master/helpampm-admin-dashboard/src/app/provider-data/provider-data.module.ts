import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { InsurancesComponent } from './insurances/insurances.component';
import { ProviderDataRoutingModule } from './provider-data-routing.module';
import { ProviderDataService } from './provider-data.service';
import { VehiclesComponent } from './vehicles/vehicles.component';
import { FormsModule } from '@angular/forms';
import { SharedModule } from '../shared/shared.module';
import { NgxDatatableModule } from '@swimlane/ngx-datatable';
import { LicenseTypeComponent } from './license/license.component';




@NgModule({
  declarations: [
    InsurancesComponent,
    VehiclesComponent,
    LicenseTypeComponent
  ],
  imports: [
    CommonModule,
    ProviderDataRoutingModule,
    FormsModule,
    SharedModule,
    NgxDatatableModule
  ],

  providers: [ProviderDataService]
})
export class ProviderDataModule { }
