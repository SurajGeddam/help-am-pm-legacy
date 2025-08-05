import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ProvidersService } from '../providers.service';


@Component({
  selector: 'app-view-provider',
  templateUrl: './view-provider.component.html',
  styleUrls: ['./view-provider.component.sass']
})
export class ViewProviderComponent implements OnInit {
  providerData: any;
  constructor(public viewProjectdialogRef: MatDialogRef<ViewProviderComponent>,
    
   
    @Inject(MAT_DIALOG_DATA) public data: any,private providersService :
    ProvidersService) {
    this.providerData = data;
  }

  ngOnInit(): void {
    this.providersService.getProviderData(this.providerData.providerUniqueId).subscribe(
      resp=>{
        this.providerData=resp;
      }
    )
  }
  steps = {
    "INDIVIDUAL": 1,
    "INSURANCE": 2,
    "LICENCE": 3,
    "VEHICLE": 4,
    "BANK": 5
  }

  isStepCompleted(currentStep, completedStep) {
    if (this.steps[currentStep] <= this.steps[completedStep]) {
      return true;
    }
    return false;
  }

  getClass(currentStep, completedStep) {
    if (this.isStepCompleted(currentStep, completedStep)) {
      return "fas fa-check-circle"
    } else {
      return "icon-close"
    }
  }

  getStyle(currentStep, completedStep) {
    if (this.isStepCompleted(currentStep, completedStep)) {
      return {
        "color": "green",
        "padding-right": "50px",
        "align-self": "flex-end"
      };
    }
    return {
      "color": "red",
      "padding-right": "50px",
      "align-self": "flex-end"
    };
  }

}
