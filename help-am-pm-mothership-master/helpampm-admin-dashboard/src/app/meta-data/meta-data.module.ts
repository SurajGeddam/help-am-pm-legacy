import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgxDatatableModule } from '@swimlane/ngx-datatable';
import { MetaDataRoutingModule } from './meta-data-routing.module';
import { MetaDataService } from './meta-data.service';

import { NgxMatDatetimePickerModule, NgxMatTimepickerModule } from '@angular-material-components/datetime-picker';
import { MessageService } from '../core/service/message.service';
import { SharedModule } from '../shared/shared.module';
import { CategoryComponent } from './category/category.component';
import { HelpComponent } from './help/help.component';
import { PricingComponent } from './pricing/pricing.component';
import { TaxComponent } from './tax/tax.component';
import { InsuranceTypeComponent } from './insurance-type/insurance-type.component';
import { LicenseTypeComponent } from './license-type/license-type.component';
import { TimeslotComponent } from './timeslot/timeslot.component';
import { OwlDateTimeModule, OwlNativeDateTimeModule } from 'ng-pick-datetime';
import { FaqComponent } from './faq/faq.component';
import { StaticContentComponent } from './static-content/static-content.component';
import { CategoryDetailComponent } from './category/category-detail/category-detail.component';
import { CommissionComponent } from './commission/commission.component';
import { CountryComponent } from './country/country.component';

@NgModule({
  declarations: [
    CategoryComponent,
    TaxComponent,
    HelpComponent,
    PricingComponent,
    TimeslotComponent,
    FaqComponent,
    StaticContentComponent,
    CategoryDetailComponent,
    LicenseTypeComponent,
    InsuranceTypeComponent,
    CommissionComponent,
    CountryComponent
  ],
  imports: [
    CommonModule,
    MetaDataRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    NgxDatatableModule,
    SharedModule,
    NgxMatDatetimePickerModule,
    NgxMatTimepickerModule,
    OwlDateTimeModule,
    OwlNativeDateTimeModule,
  ],
  providers: [MetaDataService, MessageService]
})
export class MetaDataModule { }
