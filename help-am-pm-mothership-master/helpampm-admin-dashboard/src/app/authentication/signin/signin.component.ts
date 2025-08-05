import { Component, OnInit } from '@angular/core';
import { UntypedFormBuilder, UntypedFormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { firstValueFrom } from 'rxjs';
import { AuthService } from 'src/app/core/service/auth.service';
import { ProfileService } from 'src/app/profile/profile.service';
import { UnsubscribeOnDestroyAdapter } from 'src/app/shared/UnsubscribeOnDestroyAdapter';
@Component({
  selector: 'app-signin',
  templateUrl: './signin.component.html',
  styleUrls: ['./signin.component.scss']
})
export class SigninComponent
  extends UnsubscribeOnDestroyAdapter
  implements OnInit {
  loginForm: UntypedFormGroup;
  submitted = false;
  error = '';
  hide = true;
  constructor(
    private formBuilder: UntypedFormBuilder,
    private router: Router,
    private authService: AuthService,
    private profileService: ProfileService
  ) {
    super();
  }
  ngOnInit() {
    this.loginForm = this.formBuilder.group({
      email: [
        'superadmin',
        [Validators.required, Validators.minLength(5)]
      ],
      password: ['Password@1', Validators.required]
    });
  }

  get f() {
    return this.loginForm.controls;
  }

  onSubmit() {
    this.submitted = true;
    this.error = '';
    if (this.loginForm.invalid) {
      this.error = 'Username and Password not valid !';
      return;
    } else {
      this.subs.sink = this.authService
        .login(this.f.email.value, this.f.password.value)
        .subscribe({
          next: (res) => {
            if (res) {
              localStorage.setItem('currentUser', JSON.stringify(res));
              this.authService.currentUserSubject.next(res);
              const token = this.authService.currentUserValue.token;
              this.setUserDetails();
              // const data = await firstValueFrom(this.profileService.getUser());
              // this.currentUserDetails = data;

              if (token) {
                this.router.navigate(['/dashboard/main']);
              }
            } else {
              this.error = 'Invalid Login';
            }
          },
          error: (e) => this.error = 'Invalid Login',
          complete: () => console.info('complete')
        });
    }
  }

  async setUserDetails() {
    await this.profileService.getUser().subscribe(
      res => {
        localStorage.setItem('userDetails', JSON.stringify(res));
      });
  }

}
