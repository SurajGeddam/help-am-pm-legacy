import { Component, OnInit } from '@angular/core';
import { NgbModal, NgbModalOptions } from '@ng-bootstrap/ng-bootstrap';
import { HttpService } from 'src/app/core/service/http.service';
import { ProfileService } from 'src/app/profile/profile.service';
import { ProviderDataService } from '../provider-data.service';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MessageService } from 'src/app/core/service/message.service'
@Component({
  selector: 'app-insurances',
  templateUrl: './insurances.component.html',
  styleUrls: ['./insurances.component.sass']
})
export class InsurancesComponent implements OnInit {
  minDate = new Date();
  insurances = [];
  isEdit: boolean = false;
  addEditForm: FormGroup;
  policyTypes
  constructor(
    private fb: FormBuilder,
    private profileService: ProfileService,
    private http: HttpService,
    private providerDataService: ProviderDataService,
    private messageService: MessageService,
    private modalService: NgbModal
  ) {
    this.addEditForm = this.fb.group({
      id: '',
      insurerName: ['', [Validators.required]],
      policyType: this.fb.group({
        id: ['', Validators.required]
      }),
      policyNumber: ['', [Validators.required]],
      providerUniqueId: ['', Validators.required],
      policyHolderName: ['', Validators.required],
      policyStartDate: ['', Validators.required],
      policyExpiryDate: ['', Validators.required]
    });
  }

  ngOnInit(): void {
    this.providerDataService.getInsurance().subscribe(
      resp => {
        this.insurances = resp;
      }
    )
    this.providerDataService.getInsuranceType().subscribe(
      res => {
        this.policyTypes = res;
      }
    )
  }

  showInsurancePopup(row, editForm) {
    this.isEdit = true
    let NgbModalOptionsns: NgbModalOptions = {
      backdrop: 'static',
      keyboard: false,
      ariaLabelledBy: 'modal-basic-title'
    };
    this.addEditForm.setValue({
      id: row.id,
      insurerName: row.insurerName,
      policyType: { id: row.policyType.id },
      policyNumber: row.policyNumber,
      providerUniqueId: row.providerUniqueId,
      policyHolderName: row.policyHolderName,
      policyStartDate: row.policyStartDate != null ? new Date(row.policyStartDate) : row.policyStartDate,
      policyExpiryDate: row.policyExpiryDate != null ? new Date(row.policyExpiryDate) : row.policyExpiryDate

    });
    this.modalService.open(editForm, NgbModalOptionsns);
  }
  addInsurances(content) {
    this.isEdit = false
    this.addEditForm.reset();

    let NgbModalOptions: NgbModalOptions = {
      backdrop: 'static',
      keyboard: false,
      ariaLabelledBy: 'modal-basic-title'
    };
    this.addEditForm.get("providerUniqueId").setValue(this.providerDataService.getProviderUniqueId());

    this.modalService.open(content, NgbModalOptions);
  }
  saveOrUpdateInsurance(form, isEdit) {
    this.providerDataService.saveOrEditInsurance(form.value, isEdit).subscribe(
      () => {
        form.reset();
        this.modalService.dismissAll();
        this.messageService.showSuccess('Record Added Successfully');
        this.ngOnInit();
      }
    )
  }
}
