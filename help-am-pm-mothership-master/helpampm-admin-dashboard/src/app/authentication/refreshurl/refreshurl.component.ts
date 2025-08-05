import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { AuthService } from 'src/app/core/service/auth.service';

@Component({
  selector: 'app-refreshurl',
  templateUrl: './refreshurl.component.html',
  styleUrls: ['./refreshurl.component.scss']
})
export class RefreshurlComponent implements OnInit {

  hash: string;
  stripeAccountId: string;
  providerUniqueId: string;
  accountVerificationLink;
name;
  constructor(private route: ActivatedRoute,
    private authService: AuthService
  ) {


    this.route.queryParams.subscribe(params => {
      this.hash = params['hash'];
      this.providerUniqueId = params['providerUniqueId'];
      this.stripeAccountId = params['stripeAccountId'];
      this.authService.refreshUrl(this.hash, this.providerUniqueId, this.stripeAccountId).subscribe(
        resp => {
          console.log(resp);
          this.accountVerificationLink=resp.accountVerificationLink
          this.name=resp.name;
          console.log("Sent success");
        });

    });
  }

  ngOnInit(): void {
    console.log();
  }

}
