import {
  HttpErrorResponse, HttpEvent, HttpHandler, HttpHeaders, HttpInterceptor, HttpRequest, HttpResponse
} from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { BehaviorSubject, catchError, map, Observable, switchMap, throwError } from 'rxjs';
import { AuthService } from '../service/auth.service';
import { MessageService } from '../service/message.service';

@Injectable()
export class JwtInterceptor implements HttpInterceptor {
  private isRefreshing = false;

  
  private refreshTokenSubject: BehaviorSubject<any> = new BehaviorSubject<any>(null);

  constructor(private authenticationService: AuthService,
    private router: Router,
    private messageService: MessageService) { }



  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {

    let currentUser = this.authenticationService.currentUserValue;
    let authReq = request

    if (currentUser && currentUser.token) {
      let token = currentUser.token;
      authReq = request.clone({
        headers: new HttpHeaders({
          'Authorization': `Bearer ${token}`,
          'lang_code': 'US_EN'
        })
      })
    }
    else {
      authReq = request.clone({
        headers: new HttpHeaders({
          'Content-Type': 'application/json',
          'lang_code': 'US_EN'
        })
      });
    }

    return next.handle(authReq).pipe(map(event => {
      if (event instanceof HttpResponse) {
        //this.loaderService.isLoading.next(false);
      }
      return event;
    }), catchError((error: HttpErrorResponse) => {
      //this.loaderService.isLoading.next(false);
      let errorMessage = '';
      if (error.error instanceof ErrorEvent) {
        // client-side error
        errorMessage = `Error: ${error.error.message}`;
      } else {
        // server-side error
        errorMessage = `Error Code: ${error.status}\nMessage: ${error.message}`;
      }
      if (error.status === 401 || error.status === 403) {
        return this.handle401Error(authReq, next);
      }

      else if (error.status === 0) {
        localStorage.clear();
        this.messageService.showError("Status Code 0");
        this.router.navigate(['/authentication/signin', { status: error.status }]);
      //  this.messageService.showError('Please check if you backend Service is running')
      } else {
        if (error.error.message == null) {
       //   this.messageService.showError(error.error)
        } else {
         this.messageService.showError(error.error.message)
        }
      }
      return throwError(() => new Error(error.error.message));
    })
    );

  };
  /* Refresh Token Code */
  private handle401Error(request: HttpRequest<any>, next: HttpHandler) {
    if (!this.isRefreshing) {
      this.isRefreshing = true;
      this.refreshTokenSubject.next(null);
      const newTokenRequestPayload = { username: localStorage.getItem('loggedInUserName'), refreshToken: JSON.parse(localStorage.getItem('refreshToken')) };
      let currentUser = this.authenticationService.currentUserValue;
      if (newTokenRequestPayload.refreshToken) {
        return this.authenticationService.refreshToken(newTokenRequestPayload).pipe(
          switchMap((refreshTokenResponse: any) => {
            this.isRefreshing = false;
            localStorage.removeItem('token');
            localStorage.setItem('token', refreshTokenResponse.token);
            localStorage.removeItem('refreshToken');
            localStorage.setItem('refreshToken', JSON.stringify(refreshTokenResponse.refreshToken));
            this.refreshTokenSubject.next(refreshTokenResponse.token);

            return next.handle((request.clone({
              headers: new HttpHeaders({
                'Authorization': `Bearer ${localStorage.getItem('token')}`,
              })
            })));

          }),
          catchError((err) => {
           // this.messageService.showError('Session Expired!')
            this.isRefreshing = false;
            localStorage.clear();
            this.router.navigate(['/authentication/signin']);

            return throwError(() => new Error(err.error.message));
          })
        )
      }
      else {
        localStorage.clear();
        this.router.navigate(['/authentication/signin']);
      }
    }

  }
}
