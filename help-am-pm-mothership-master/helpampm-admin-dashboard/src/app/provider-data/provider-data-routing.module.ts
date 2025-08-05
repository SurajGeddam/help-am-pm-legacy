import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { VehiclesComponent } from './vehicles/vehicles.component';
import { InsurancesComponent } from './insurances/insurances.component';
import { LicenseTypeComponent } from './license/license.component';
const routes: Routes = [
  {
    path: 'vehicles',
    component: VehiclesComponent
  },
  {
    path: 'insurances',
    component: InsurancesComponent
  },
  {
    path: 'licenses',
    component: LicenseTypeComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProviderDataRoutingModule { }
