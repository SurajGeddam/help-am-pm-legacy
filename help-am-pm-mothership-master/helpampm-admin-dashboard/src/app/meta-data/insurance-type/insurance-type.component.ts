import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { NgbModal, NgbModalOptions } from '@ng-bootstrap/ng-bootstrap';
import { DatatableComponent } from '@swimlane/ngx-datatable';
import { FilterService } from 'src/app/core/service/filter.service';
import { MessageService } from 'src/app/core/service/message.service';
import { ConfirmDialogComponent, ConfirmDialogModel } from 'src/app/shared/components/confirm-dialog/confirm-dialog.component';
import { MetaDataService } from '../meta-data.service';

@Component({
  selector: 'app-insurance-type',
  templateUrl: './insurance-type.component.html',
  styleUrls: ['./insurance-type.component.sass']
})
export class InsuranceTypeComponent implements OnInit {

  @ViewChild(DatatableComponent, { static: false }) table: DatatableComponent;

  rows = [];
  data = [];
  filteredData = [];

  editForm: FormGroup;
  isEdit: boolean = false;

  insuranceType: any;

  constructor(
    private fb: FormBuilder,
    public dialog: MatDialog,
    private modalService: NgbModal,
    private metaDataService: MetaDataService,
    private messageService: MessageService,
    private filterService: FilterService
  ) {
    this.editForm = this.fb.group({
      id: new FormControl(),
      name: ['', [Validators.required]]
    });
  }

  ngOnInit() {
    this.getData();
  }

  /**
   * @method getData
   * @Description get's All InsuranceTypees from the metadaService
   */
  getData() {
    this.metaDataService.getAllInsuranceType().subscribe(
      (res: any) => {
        this.data = res;
        this.filteredData = this.data;
      }
    )
  }

  /**
   * @method edit
   * @param insuranceType 
   * @param content 
   * @param isEdit
   * @description open's the modal for the Edit and add InsuranceType
   */

   editInsuranceType(insuranceType, content, isEdit) {
    this.editForm.reset();
    this.isEdit = isEdit;
    let ngbModalOptions: NgbModalOptions = {
      backdrop: 'static',
      keyboard: false,
      ariaLabelledBy: 'modal-basic-title'
    };
    this.modalService.open(content, ngbModalOptions);
    if (isEdit) {
      this.editForm.setValue({
        id: insuranceType.id,
        name: insuranceType.name,
        isActive: insuranceType.isActive
      });
    }
  }
  openDeleteInsuranceType(data: any) {
    this.insuranceType = data;
    const dialogData = new ConfirmDialogModel("Confirm Action", "Are you sure you want to Delete InsuranceType?");
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      maxWidth: "400px",
      data: dialogData
    });


    dialogRef.afterClosed().subscribe(dialogResult => {
      if (dialogResult) {
        let insuranceType = {
          id: this.insuranceType.id,
          isActive: false
        }

        this.metaDataService.updateInsuranceType(insuranceType).subscribe((res: any) => {
          var data: any;
          data = res;
          this.messageService.showSuccess("Insurance Type " + data.name + " Deleted successfully")
        });
      }
    });


  }
  /**
   * @method onEditSave
   * @param form 
   * @description Save's the edit end add InsuranceType Form
   */
  onEditSave(form: FormGroup) {
    if (form.valid && this.isEdit) {
      // Edit Form Submit
      this.metaDataService.updateInsuranceType(form.value).subscribe((res: any) => {
        this.updateObjectInList(res);
        this.editForm.reset();
        this.modalService.dismissAll();
        this.messageService.showSuccess("Record Edited Successfully");
      }
      )
    } else if (form.valid && !this.isEdit) {
      form.value['isActive'] = true;
      // Add form Submit
      this.metaDataService.createInsuranceType(form.value).subscribe(
        res => {
          form.reset();
          this.modalService.dismissAll();
          this.messageService.showSuccess('Record Added Successfully');
          this.data.unshift(res);
          this.data = [...this.data];
        }
      )
    }
  }

  /**
   * @method updateObjectInList
   * @param object 
   * @description add the updated object on the top of the list of InsuranceType's
   */
  updateObjectInList(object) {
    const data = this.data.filter(ele => ele.id != object.id);
    data.unshift(object);
    this.data = [...data];
  }

  /**
   * @method filterDatatable
   * @param event 
   * @description search for the filter data table
   */
  filterDatatable(event) {
    this.data = this.filterService.filter(event, this.filteredData, this.data);
    this.table.offset = 0;
  }

  changeStatus(event, row) {
    let insuranceType = row;
    insuranceType = {
      id: row.id,
      isActive: event.checked
    }

    this.metaDataService.updateInsuranceType(insuranceType).subscribe((res: any) => {
      var data: any;
      data = res;
      if (data.isActive) {
        this.messageService.showSuccess("InsuranceType " + data.name + " Enabled successfully")
      } else {
        this.messageService.showSuccess("InsuranceType " + data.name + "  Disabled successfully")
      }

    });
  }

}
