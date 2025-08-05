import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AuthService } from 'src/app/core/service/auth.service';

@Component({
  selector: 'app-verificationStatus',
  templateUrl: './verificationStatus.component.html',
  styleUrls: ['./verificationStatus.component.scss']
})

export class VerificationStatusComponent implements OnInit {
  hash: string;
  stripeAccountId: string;
  providerUniqueId: string;
  accountVerificationLink;
  name;
  status;
  message;
  verifyResonse:boolean=false;
  completed:boolean=false;
  inProcess:boolean=false;


  constructor(private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService
  ) {

    this.route.queryParams.subscribe(params => {
      
      this.hash = params['hash'];
      this.providerUniqueId = params['providerUniqueId'];
      this.stripeAccountId = params['stripeAccountId'];
      this.authService.checkVerificationStatus(this.hash, this.providerUniqueId, this.stripeAccountId).subscribe(
        resp => {
          this.verifyResonse=true;
          console.log(resp);
          this.accountVerificationLink = resp.accountVerificationLink
          this.name = resp.name;
          this.status=resp.status;
          this.message=resp.message;

          if(this.status=='inprocess'){
            this.inProcess=true;
          }
          if(this.status=='completed'){
            this.completed=true;
          }

          console.log("Sent success");
        });

    });

  }


  ngOnInit() { }

  submit() {
    this.router.navigate(['/authentication/signin']);
  }
}
