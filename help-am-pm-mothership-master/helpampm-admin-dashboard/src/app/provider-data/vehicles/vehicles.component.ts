import { Component, OnInit } from '@angular/core';
import { ProfileService } from 'src/app/profile/profile.service';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NgbModal, NgbModalOptions } from '@ng-bootstrap/ng-bootstrap';
import { MessageService } from 'src/app/core/service/message.service';
import { ProviderDataService } from '../provider-data.service';
import { HttpService } from 'src/app/core/service/http.service';
import { MAT_DATE_FORMATS } from '@angular/material/core';
import * as moment from 'moment';

export const MY_DATE_FORMATS = {
  parse: {
    dateInput: 'YYYY-MM-DD',
  },
  display: {
    dateInput: 'YYYY-MM-DD',
    monthYearLabel: 'MMMM YYYY',
    dateA11yLabel: 'YYYY-MM-DD',
    monthYearA11yLabel: 'MMMM YYYY'
  },
};
@Component({
  selector: 'app-vehicles',
  templateUrl: './vehicles.component.html',
  styleUrls: ['./vehicles.component.sass'],
  // providers: [
  //   // `MomentDateAdapter` can be automatically provided by importing `MomentDateModule` in your
  //   // application's root module. We provide it at the component level here, due to limitations of
  //   // our example generation script.
  //   {
  //     provide: DateAdapter,
  //     useClass: MomentDateAdapter,
  //     deps: [MAT_DATE_LOCALE, MAT_MOMENT_DATE_ADAPTER_OPTIONS],
  //   },
  //   {provide: MAT_DATE_FORMATS, useValue: MY_FORMATS},
  // ],
  providers: [
    { provide: MAT_DATE_FORMATS, useValue: MY_DATE_FORMATS }
  ]
})
export class VehiclesComponent implements OnInit {
  minDate = new Date();
  vehicles = [];
  addEditForm: FormGroup;
  isEdit: boolean = false;
  insuranceTypes
  constructor(
    private fb: FormBuilder,
    private modalService: NgbModal,
    private messageService: MessageService,
    private providerDataService: ProviderDataService
  ) {
    this.addEditForm = this.fb.group({
      id: '',
      model: ['', [Validators.required]],
      manufacturer: ['', [Validators.required]],
      yearOfMaking: ['', [Validators.required, Validators.minLength(4),
      Validators.maxLength(4),
      Validators.pattern('^[0-9]*$')]],
      numberPlate: ['', Validators.required],
      vin: ['', Validators.required],
      providerUniqueId: ['', Validators.required],
      insurance: this.fb.group({
        insurerName: ['', Validators.required],
        policyType: this.fb.group({
          id: ['', Validators.required],
        }),
        policyNumber: ['', Validators.required],
        policyHolderName: ['', Validators.required],
        policyStartDate: ['', Validators.required],
        policyExpiryDate: ['', Validators.required],
        providerUniqueId: ['', Validators.required]
      })

    });

  }
  ngOnInit(): void {
    this.providerDataService.getVehicles().subscribe(
      resp => {
        this.vehicles = resp;
      }
    )
    this.providerDataService.getInsuranceType().subscribe(
      res => {
        this.insuranceTypes = res;
      }
    )
  }
  showVehiclePopup(row, editForm) {
    this.isEdit = true
    let NgbModalOptionsns: NgbModalOptions = {
      backdrop: 'static',
      keyboard: false,
      ariaLabelledBy: 'modal-basic-title'
    };

    this.addEditForm.setValue({
      id: row.id,
      model: row.model,
      manufacturer: row.manufacturer,
      yearOfMaking: row.yearOfMaking,
      numberPlate: row.numberPlate,
      vin: row.vin,
      providerUniqueId: row.providerUniqueId,
      insurance: {
        insurerName: row.insurance.insurerName,
        policyType: {
          id: row.insurance.policyType.id,
        },
        policyNumber: row.insurance.policyNumber,
        policyHolderName: row.insurance.policyHolderName,
        policyStartDate: row.insurance.policyStartDate != null ? new Date(row.insurance.policyStartDate) : row.insurance.policyStartDate,
        policyExpiryDate: row.insurance.policyExpiryDate != null ? new Date(row.insurance.policyExpiryDate) : row.insurance.policyExpiryDate,
        providerUniqueId: row.insurance.providerUniqueId
      }
    });
    this.modalService.open(editForm, NgbModalOptionsns);
  }


  addVehicle(content) {
    this.isEdit = false
    this.addEditForm.reset();
    let ngbModalOptions: NgbModalOptions = {
      backdrop: 'static',
      keyboard: false,
      ariaLabelledBy: 'modal-basic-title'
    };
    this.addEditForm.get("providerUniqueId").setValue(this.providerDataService.getProviderUniqueId());
    this.addEditForm.get('insurance').get('providerUniqueId').setValue(this.providerDataService.getProviderUniqueId());
    this.modalService.open(content, ngbModalOptions);
  }


  saveOrUpdateVehicle(form, isEditRequest) {
    this.providerDataService.saveOrEditVehicle(form.value, isEditRequest).subscribe(
      () => {
        form.reset();
        this.modalService.dismissAll();
        this.messageService.showSuccess('Record Added Successfully');
        this.ngOnInit()
      }
    )
  }
}
