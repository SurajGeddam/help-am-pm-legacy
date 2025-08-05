import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NgbModal, NgbModalOptions } from '@ng-bootstrap/ng-bootstrap';
import { MessageService } from 'src/app/core/service/message.service';
import { ProviderDataService } from '../provider-data.service';

@Component({
  selector: 'app-license',
  templateUrl: './license.component.html',
  styleUrls: ['./license.component.sass']
})
export class LicenseTypeComponent implements OnInit {
  minDate = new Date();
  license = [];
  addEditForm: FormGroup;
  isEdit: boolean = false;
  licenseTypes
  constructor(
    private fb: FormBuilder,
    private modalService: NgbModal,
    private messageService: MessageService,
    private providerDataService: ProviderDataService
  ) {
    this.addEditForm = this.fb.group({
      id: '',
      issuedBy: ['', Validators.required],
      licenseType: this.fb.group({
        id: ['', Validators.required]
      }),
      registeredState: ['', Validators.required],
      licenseNumber: ['', Validators.required],
      providerUniqueId: ['', Validators.required],
      licenseHolderName: ['', Validators.required],
      licenseStartDate: ['', Validators.required],
      licenseExpiryDate: ['', Validators.required]

    });
  }
  ngOnInit(): void {
    this.providerDataService.getLicenses().subscribe(
      resp => {
        this.license = resp;
      })
    this.providerDataService.getLicenseTypes().subscribe(
      res => {
        this.licenseTypes = res;
      }
    )
  }
  showLicensePopup(row, editForm) {
    this.isEdit = true
    let NgbModalOptionsns: NgbModalOptions = {
      backdrop: 'static',
      keyboard: false,
      ariaLabelledBy: 'modal-basic-title'
    };
    this.addEditForm.setValue({
      id: row.id,
      issuedBy: row.issuedBy,
      licenseType: { id: row.licenseType.id },
      registeredState: row.registeredState,
      licenseNumber: row.licenseNumber,
      providerUniqueId: row.providerUniqueId,
      licenseHolderName: row.licenseHolderName,
      licenseStartDate: row.licenseStartDate != null ? new Date(row.licenseStartDate) : row.licenseStartDate,
      licenseExpiryDate: row.licenseExpiryDate != null ? new Date(row.licenseExpiryDate) : row.licenseExpiryDate

    });
    this.modalService.open(editForm, NgbModalOptionsns);
  }
  addLicense(content) {
    this.isEdit = false
    this.addEditForm.reset();
    let ngbModalOptions: NgbModalOptions = {
      backdrop: 'static',
      keyboard: false,
      ariaLabelledBy: 'modal-basic-title'
    };
    this.addEditForm.get("providerUniqueId").setValue(this.providerDataService.getProviderUniqueId());
    this.modalService.open(content, ngbModalOptions);

  }
  saveOrUpdateLicense(form, isEditRequest) {
    this.providerDataService.saveOrEditLicense(form.value, isEditRequest).subscribe(
      () => {
        form.reset();
        this.modalService.dismissAll();
        this.messageService.showSuccess('Record Added Successfully');
        this.ngOnInit();
      }
    )
  }
}
