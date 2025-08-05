import { Injectable } from '@angular/core';
import { HttpService } from '../core/service/http.service';

@Injectable({
  providedIn: 'root'
})
export class MetaDataService {

  constructor(private http: HttpService) { }


  getAllCategory() {
    return this.http.get('category')
  }

  getCategoryById(id: number) {
    return this.http.get(`category/${id}`);
  }

  updateCategory(data: any) {
    return this.http.put('category', data);
  }
  
  updatePricing(timeslotId,data: any) {
    return this.http.put(`pricing/${timeslotId}`, data);
  }


  getAllTimeslot() {
    return this.http.get('timeslot')
  }

  createTimeslot(data) {
    return this.http.post('timeslot', data);
  }

  updateTimeslotStatus(id, data) {
    return this.http.put(`timeslot/status/${id}`, data);
  }

  getAllSupportInfo() {
    return this.http.get('help/support_info');
  }
  updateHelpAndSuporr(data) {
    return this.http.put('help/support_info', data);
  }
  createHelpAndSuporr(data) {
    return this.http.post('help/support_info', data);

  }

  getAllPricing() {
    return this.http.get('pricing')
  }

  //Taxes
  getAllTax() {
    return this.http.get('tax')
  }

  updateTax(data) {
    return this.http.put('tax',data)
  }

  createTax(data) {
    return this.http.post('tax',data)
  }
// Country
  getAllCountry() {
    return this.http.get('country/all')
  }
   updateCountry(data) {
      return this.http.put('country',data)
    }

    createCountry(data) {
      return this.http.post('country',data)
    }

  //FAQs
  // help/faq
  getAllFaq() {
    return this.http.get('help/faq/all');
  }

  createFaq(faq) {
    return this.http.post('help/faq', faq);
  }

  updateFaq(faq) {
    return this.http.put('help/faq', faq);
  }

  deleteFaq(faqId) {
    return this.http.delete(`help/faq/${faqId}`);
  }

  getAllInsuranceType() {
    return this.http.get('insurance-type');
  }

  createInsuranceType(insuranceType) {
    return this.http.post('insurance-type', insuranceType);
  }
  updateInsuranceType(insuranceType) {
    return this.http.put('insurance-type', insuranceType);
  }

  getAllLicenseType() {
    return this.http.get('license-type');
  }
  
  createLicenseType(licenseType) {
    return this.http.post('license-type', licenseType);
  }
  updateLicenseType(licenseType) {
    return this.http.put('license-type', licenseType);
  }

  getCommission() {
   return this.http.get('commission');
  }
  createCommission(commission){
    return this.http.post('commission', commission);
  }
  updateCommission(commission){
    return this.http.put('commission', commission);
  }
}
