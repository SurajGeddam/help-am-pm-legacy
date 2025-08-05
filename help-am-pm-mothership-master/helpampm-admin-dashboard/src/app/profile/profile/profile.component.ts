import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Subscription } from 'rxjs';
import { MessageService } from 'src/app/core/service/message.service';
import { ProfileService } from '../profile.service';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.sass']
})
export class ProfileComponent implements OnInit {

  user;
  subscription: Subscription;
  passwordForm!: FormGroup;
  file = new FormControl();
  userRole;
  constructor(
    private fb: FormBuilder,
    private profileService: ProfileService,
    private msgService: MessageService) {
    this.createPasswordForm();
  }

  ngOnInit() {
    const userName = localStorage.getItem("currentUser");
    this.userRole = JSON.parse(userName).role;
    this.profileService.getUser().subscribe(
      res => {
        let loggedInuser = res;
        if (loggedInuser.authority == 'ROLE_PROVIDER_ADMIN') {
          this.profileService.getProvider(loggedInuser.providerUniqueId).subscribe(res => {
            this.user = res;
          })
        }else{
          this.user=res;
        }
      }
    )
  }

  createPasswordForm() {
    this.passwordForm = this.fb.group({
      oldPassword: ['', [Validators.required, Validators.minLength(5)]],
      newPassword: ['', [Validators.required, Validators.minLength(5)]],
    })
  }

  submit() {
    if (this.passwordForm.valid) {
      const param = this.passwordForm.value;
      param.username = this.user.username;
      this.profileService.changePassword(param).subscribe(
        res => {
          this.msgService.showSuccess("Password Changed successfully")
        }
      )
    }
  }


  isProvider() {
    if (this.userRole == 'ROLE_PROVIDER_ADMIN') {
      return true;
    }
  }
}
