import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { HttpService } from '../core/service/http.service';
import { UnsubscribeOnDestroyAdapter } from '../shared/UnsubscribeOnDestroyAdapter';

@Injectable()
export class NotificationsService extends UnsubscribeOnDestroyAdapter {
  isTblLoading = true;
  dataChange: BehaviorSubject<any[]> = new BehaviorSubject<any[]>([]);

  // Temporarily stores data from dialogs
  dialogData: any;
  constructor(private httpClient: HttpService) {
    super();
  }

  getRecentNotifications() {
    return this.httpClient.get("notification/type");
  }
  
  getAllNotifications(pageParams) {
    return this.httpClient.post("notification/pageableNotifications",pageParams);
  }
}
