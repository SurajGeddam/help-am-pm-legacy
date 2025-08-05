import { NgModule } from '@angular/core';
import { FileUploadComponent } from './file-upload/file-upload.component';

import { ConfirmDialogComponent } from './confirm-dialog/confirm-dialog.component';
import { MaterialModule } from '../material.module';
@NgModule({
  declarations: [FileUploadComponent, ConfirmDialogComponent],
  imports: [MaterialModule],
  exports: [FileUploadComponent,ConfirmDialogComponent]
})
export class ComponentsModule { }
