import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { AddUserComponent as advanceTableForm } from './dialogs/add-user/add-user.component';
import { DeleteDialogComponent } from './dialogs/delete/delete.component';
import { UserManagementRoutingModule } from './user-management-routing.module';
import { UserManagementComponent } from './user-management.component';

import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { NgxDatatableModule } from '@swimlane/ngx-datatable';
import { NgxMaskModule } from 'ngx-mask';
import { MessageService } from '../core/service/message.service';
import { SharedModule } from '../shared/shared.module';
import { UserManagementService } from './user-management.service';


@NgModule({
  declarations: [
    UserManagementComponent,
    advanceTableForm,
    DeleteDialogComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    UserManagementRoutingModule,
    NgxDatatableModule,
    MatProgressSpinnerModule,
    SharedModule,
    NgbModule,
    NgxMaskModule.forRoot(),
  ],
  providers: [UserManagementService, MessageService]
})
export class UserManagementModule { }
