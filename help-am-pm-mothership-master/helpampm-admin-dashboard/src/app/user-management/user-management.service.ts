import { Injectable } from '@angular/core';
import { HttpService } from '../core/service/http.service';

@Injectable()
export class UserManagementService {
  constructor(private httpService: HttpService) {
    const userName = localStorage.getItem("userDetails");
    
  }

  dialogData: any;

  /** CRUD METHODS */

  getAllEmployees(parentCompanyUniqueId) {
    return this.httpService.get(`provider/employees/${parentCompanyUniqueId}`);
  }

  createUser(userData: any, companyUniqueId) {
    return this.httpService.post(`provider/signup/${companyUniqueId}`, userData);
  }

  updateEmployee(employeeData: any,companyUniqueId,providerUniqueId) {
    return this.httpService.put(`provider/employee/${companyUniqueId}/${providerUniqueId}`, employeeData);
  }

  // changePassword(data) {
  //   return this.httpService.put('user/password/change', data);
  // }
  
  getDialogData() {
    return this.dialogData;
  }

}
