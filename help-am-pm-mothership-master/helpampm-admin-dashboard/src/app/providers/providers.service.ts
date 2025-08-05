import { Injectable } from '@angular/core';
import { HttpService } from '../core/service/http.service';
import { UnsubscribeOnDestroyAdapter } from '../shared/UnsubscribeOnDestroyAdapter';

@Injectable()
export class ProvidersService extends UnsubscribeOnDestroyAdapter {
 
  // Temporarily stores data from dialogs
  dialogData: any;
  constructor(private httpClient: HttpService) {
    super();
  }
  
  /** CRUD METHODS */
  getAllProviders(pageParams) {
    return this.httpClient.post("provider/pageableProviders",pageParams);
  }
  activeInactiveProviders(data) {
   
    return this.httpClient.put(`provider/${data.id}/isActive/${data.isActive}`,data);
  }

  sendAccountCompleteReminder(providerUniqueId) {
    return this.httpClient.get(`provider/reminders/${providerUniqueId}`);
  }
  getProviderData(providerUniqueId){
    return this.httpClient.get("provider/"+providerUniqueId);
  }
}
