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
  selector: 'app-tax',
  templateUrl: './tax.component.html',
  styleUrls: ['./tax.component.sass']
})
export class TaxComponent implements OnInit {

  @ViewChild(DatatableComponent, { static: false }) table: DatatableComponent;

  rows = [];
  data = [];
  filteredData = [];

  editForm: FormGroup;
  isEdit: boolean = false;

  tax: any;

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
      taxCounty: ['', [Validators.required]],
      taxRate: ['', Validators.required],
      taxName: ['', Validators.required],
      taxPeriod: ['', Validators.required],
      isActive: ['']
    });
  }

  ngOnInit() {
    this.getData();
  }

  /**
   * @method getData
   * @Description get's All Taxes from the metadaService
   */
  getData() {
    this.metaDataService.getAllTax().subscribe(
      (res: any) => {
        this.data = res;
        this.filteredData = this.data;
      }
    )
  }

  /**
   * @method edit
   * @param tax 
   * @param content 
   * @param isEdit
   * @description open's the modal for the Edit and add Tax
   */

  editTax(tax, content, isEdit) {
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
        id: tax.id,
        taxCounty: tax.taxCounty,
        taxName: tax.taxName,
        taxRate: tax.taxRate,
        taxPeriod: tax.taxPeriod,
        isActive: tax.isActive
      });
    }
  }
  openDeleteTax(data: any) {

    this.tax = data;

    const dialogData = new ConfirmDialogModel("Confirm Action", "Are you sure you want to Delete Tax?");
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      maxWidth: "400px",
      data: dialogData
    });


    dialogRef.afterClosed().subscribe(dialogResult => {
      if (dialogResult) {
        let tax = {
          id: this.tax.id,
          isActive: false
        }

        this.metaDataService.updateTax(tax).subscribe((res: any) => {
          var data: any;
          data = res;
          this.messageService.showSuccess("Tax " + data.firstName + " Deleted successfully")
        });
      }
    });


  }
  /**
   * @method onEditSave
   * @param form 
   * @description Save's the edit end add Tax Form
   */
  onEditSave(form: FormGroup) {
    if (form.valid && this.isEdit) {
      // Edit Form Submit
      this.metaDataService.updateTax(form.value).subscribe((res: any) => {
        this.updateObjectInList(res);
        this.editForm.reset();
        this.modalService.dismissAll();
        this.messageService.showSuccess("Record Edited Successfully");
      }
      )
    } else if (form.valid && !this.isEdit) {
      form.value['isActive'] = true;
      // Add form Submit
      this.metaDataService.createTax(form.value).subscribe(
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
   * @description add the updated object on the top of the list of Tax's
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
    let tax = row;
    tax = {
      id: row.id,
      isActive: event.checked
    }

    this.metaDataService.updateTax(tax).subscribe((res: any) => {
      var data: any;
      data = res;
      if (data.isActive) {
        this.messageService.showSuccess("Tax Enabled successfully")
      } else {
        this.messageService.showSuccess("Tax Disabled successfully")
      }

    });
  }

}
