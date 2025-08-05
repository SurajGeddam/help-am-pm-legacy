import { Injectable } from '@angular/core';
import {
  ActivatedRouteSnapshot, CanActivate, Router, RouterStateSnapshot
} from '@angular/router';

import { AuthService } from '../service/auth.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {
  constructor(private authService: AuthService, private router: Router) { }

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    let user = JSON.parse(localStorage.getItem("currentUser"));
    let role = user.role;

    if (role == "ROLE_PROVIDER_ADMIN"
      || role == "ROLE_SUPERADMIN" || "ROLE_PROVIDER_EMPLOYEE") {
      return true;
    }
    console.log("Not authorized to access")
    this.router.navigate(['/authentication/signin']);
    return false;
  }
}
