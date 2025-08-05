import { Injectable } from '@angular/core';
import { ProfileService } from '../profile/profile.service';
import { HttpService } from '../core/service/http.service';
import * as moment from 'moment';

@Injectable({
  providedIn: 'root'
})
export class ProviderDataService {
  loggedInUser
  constructor(private profileService: ProfileService,
    private http: HttpService) {
    console.log('ProviderDataService is constructed');
    this.profileService.getUser().subscribe(
      res => {
        this.loggedInUser = res;
      })
  }

  getVehicles(): any {

    return this.http.get('vehicle/' + this.getProviderUniqueId())

  }
  getProviderUniqueId() {
    return JSON.parse(localStorage.getItem('userDetails')).providerUniqueId
  }
  getInsuranceType() {
    return this.http.get('insurance-type/all')
  }
  getLicenses() {
    return this.http.get('license/' + this.getProviderUniqueId())
  }
  getInsurance() {
    return this.http.get('insurance/' + this.getProviderUniqueId())
  }
  getLicenseTypes() {
    return this.http.get('license-type/all')
  }

  saveOrEditVehicle(data, isUpdateRequest) {
    if (isUpdateRequest) {
      return this.http.put('provider/' + this.getProviderUniqueId() + '/vehicle', data)
    } else {
      return this.http.post('provider/' + this.getProviderUniqueId() + '/vehicle', data);
    }
  }
  saveOrEditLicense(data,isUpdateRequest) {
    if(isUpdateRequest){
      return this.http.put('provider/' + this.getProviderUniqueId() + '/license', data);
    }else{
    return this.http.post('provider/' + this.getProviderUniqueId() + '/license', data);
  }}
  saveOrEditInsurance(data,isUpdateRequest) {
    if(isUpdateRequest){
      return this.http.put('provider/' + this.getProviderUniqueId() + '/insurance', data);
    }else{
    return this.http.post('provider/' + this.getProviderUniqueId() + '/insurance', data);
  }
}}
