import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { NgxDatatableModule } from '@swimlane/ngx-datatable';
import { SharedModule } from '../shared/shared.module';
import { ProvidersRoutingModule } from './providers-routing.module';
import { ProvidersComponent } from './providers.component';
import { ProvidersService } from './providers.service';
import { ViewProviderComponent } from './view-provider/view-provider.component';

@NgModule({
  declarations: [
    ProvidersComponent,
    ViewProviderComponent,
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    ProvidersRoutingModule,
    SharedModule,
    NgxDatatableModule,
  ],
  providers: [ProvidersService]
})
export class ProvidersModule {}
