import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable, of } from 'rxjs';
import { User } from '../models/user';
import { HttpService } from './http.service';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  public currentUserSubject: BehaviorSubject<User>;
  public currentUser: Observable<User>;

  constructor(private http: HttpService) {

    this.currentUserSubject = new BehaviorSubject<User>(
      JSON.parse(localStorage.getItem('currentUser'))
    );

    this.currentUser = this.currentUserSubject.asObservable();
  }

  public get currentUserValue(): User {
    return this.currentUserSubject.value;
  }

  refreshToken(body: any) {
    return this.http.post('auth/refreshtoken', body);
  }

  login(username: string, password: string) {
    
    return this.http.post('auth/token?loginSource=browser', {
        'username':username,
        'password':password
      });
  }

  logout() {
    // remove user from local storage to log user out
    localStorage.removeItem('currentUser');
    localStorage.removeItem('userDetails');
    this.currentUserSubject.next(null);
    return of({ success: false });
  }

  // in case of refresh regenrate the URL
  refreshUrl(hash,providerUniqueId,stripeAccountId) {
    return this.http.get(`auth/provider/refreshUrl?stripeAccountId=${stripeAccountId}&providerUniqueId=${providerUniqueId}&hash=${hash}`);
  }

  // verification status check of stripe from the backedn for error
  checkVerificationStatus(hash,providerUniqueId,stripeAccountId) {
    return this.http.get(`auth/provider/returnUrl?stripeAccountId=${stripeAccountId}&providerUniqueId=${providerUniqueId}&hash=${hash}`);
  }


}
