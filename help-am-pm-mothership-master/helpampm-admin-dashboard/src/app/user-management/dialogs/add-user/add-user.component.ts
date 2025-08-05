import { Component, Inject } from '@angular/core';
import {
  FormBuilder, FormControl,

  FormGroup, Validators
} from '@angular/forms';
import { MAT_DATE_LOCALE } from '@angular/material/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MessageService } from 'src/app/core/service/message.service';
import { UserManagementService } from '../../user-management.service';

@Component({
  selector: 'app-form-dialog',
  templateUrl: './add-user.component.html',
  styleUrls: ['./add-user.component.sass'],
  providers: [{ provide: MAT_DATE_LOCALE, useValue: 'en-GB' }]
})
export class AddUserComponent {

  action: string;
  dialogTitle: string;
  addUserForm: FormGroup;
  editUserForm: FormGroup;
  userDetails: any;
  userData: any;
  startDate = new Date(1990, 0, 1);
  submitted: boolean = false;
  today = new Date();

  constructor(
    public dialogRef: MatDialogRef<AddUserComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public userManagementService: UserManagementService,
    private fb: FormBuilder,
    private messageService: MessageService
  ) {

    this.userDetails = JSON.parse(localStorage.getItem("userDetails"));

    this.action = data.action;
    if (this.action === 'edit') {
      this.dialogTitle = data.userData.name;
      this.userData = data;
      this.addUserForm = this.createContactForm();
    } else {
      this.dialogTitle = 'New Employee';
      this.addUserForm = this.createContactForm();
    }
  }




  createContactForm(): FormGroup {
    if (this.userData) {
      const userData = this.userData.userData;
      return this.fb.group({
        name: new FormControl(userData.name, [Validators.required]),
        website: new FormControl(userData.website, []),
        email: new FormControl(userData.email, [Validators.required, Validators.email]),
        phone: new FormControl(userData.phone, [Validators.required]),
      });
    } else {
      return this.fb.group({
        name: new FormControl(null, [Validators.required]),
        website: new FormControl(null, []),
        email: new FormControl(null, [Validators.required, Validators.email]),
        phone: new FormControl(null, [Validators.required]),
        userLoginDetails: this.fb.group({
          username: new FormControl(null, [Validators.required]),
          password: new FormControl(null, [Validators.required]),
        })
      });
    }
  }


  public confirmAdd(): void {
    this.submitted = true;
    if (this.action === 'edit') {
      if (this.addUserForm.invalid) {
        return;
      }
      const user = this.addUserForm.value;
      this.userManagementService.updateEmployee(user,this.userDetails.companyUniqueId,this.userDetails.providerUniqueId).subscribe((res: any) => {
        this.userManagementService.dialogData = res;
        this.dialogRef.close('closed');
        this.submitted = false;
        this.messageService.showSuccess("User Edited successfullly.")
      });

    } else {
      if (this.addUserForm.invalid) {
        return;
      }
      const user = this.addUserForm.value;
      this.userDetails.providerUniqueId
      //filter role on id
      this.userManagementService.createUser(user, this.userDetails.companyUniqueId).subscribe((res: any) => {
        this.userManagementService.dialogData = res;
        this.dialogRef.close('closed');
        this.submitted = false;
      });
    }
  }

}
