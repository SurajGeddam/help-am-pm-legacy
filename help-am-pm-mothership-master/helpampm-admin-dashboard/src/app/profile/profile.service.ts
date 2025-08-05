import { Injectable } from '@angular/core';
import { HttpService } from '../core/service/http.service';

@Injectable({
  providedIn: 'root'
})
export class ProfileService {

  constructor(private httpService: HttpService) { }

  changePassword(data) {
    return this.httpService.put('auth/password/change', data);
  }

  getUser() {
    return this.httpService.get(`auth/profile`);
  }

  // async getUserSync() {
  //   let va= await this.httpService.get(`auth/profile`);
  //   return va;
  // }

  getProvider(uniqueId) {
    return this.httpService.get(`provider/${uniqueId}`);

  }

}
