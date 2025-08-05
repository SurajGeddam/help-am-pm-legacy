
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
  selector: 'app-country',
  templateUrl: './country.component.html',
  styleUrls: ['./country.component.sass']
})
export class CountryComponent implements OnInit {

  @ViewChild(DatatableComponent, { static: false }) table: DatatableComponent;

  rows = [];
  data = [];
  filteredData = [];

  editForm: FormGroup;
  isEdit: boolean = false;

  country: any;

  constructor(
    private fb: FormBuilder,
    public dialog: MatDialog,
    private modalService: NgbModal,
    private metaDataService: MetaDataService,
    private messageService: MessageService,
    private filterService: FilterService
   
  ) {
    this.editForm = this.fb.group({
      id: ['', []],
      name: ['', [Validators.required]],
      dialCode: ['', Validators.required],
      code: ['', Validators.required],
      // isActive: ['', [Validators.required]],

    });
  }

  ngOnInit() {
    this.getData();
  }

  /**
   * @method getData
   * @Description gets All Countries from the metadataService
   */
  getData() {
    this.metaDataService.getAllCountry().subscribe(
      (res: any) => {
        this.data = res;
        this.filteredData = this.data;
      }
    )
  }
  /**
   * @method edit
   * @param country
   * @param content
   * @param isEdit
   * @description open's the modal for the Edit and add Country
   */

  editCountry(country, content, isEdit) {
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
        id: country.id,
        name: country.name,
        dialCode: country.dialCode,
        code: country.code,
        // isActive: country.isActive,
      });
    }
  }
  openDeleteCountry(data: any) {

    this.country = data;

    const dialogData = new ConfirmDialogModel("Confirm Action", "Are you sure you want to Delete country?");
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      maxWidth: "400px",
      data: dialogData
    });


    dialogRef.afterClosed().subscribe(dialogResult => {
      if (dialogResult) {
        let country = {

          isActive: false
        }

        this.metaDataService.updateCountry(country).subscribe((res: any) => {
          var data: any;
          data = res;
          this.messageService.showSuccess("Country " + data.firstName + " Deleted successfully")
          this.getData()
        });
      }
    });


  }
  /**
   * @method onEditSave
   * @param form
   * @description Save's the edit end add Country Form
   */
  onEditSave(form: FormGroup) {
    if (form.valid && this.isEdit) {
      // Edit Form Submit
      this.metaDataService.updateCountry(form.value).subscribe((res: any) => {
        this.editForm.reset();
        this.modalService.dismissAll();
        this.getData();
        this.messageService.showSuccess("Record Edited Successfully");
      }
      )
    } else if (form.valid && !this.isEdit) {
      form.value['isActive'] = true

      // Add form Submit
      this.metaDataService.createCountry(form.value).subscribe(
        () => {
          form.reset();
          this.modalService.dismissAll();
          this.messageService.showSuccess('Record Added Successfully');
          this.getData();
        }
      )
    }

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
    let country = row;
    country = {
      isActive: event.checked
    }

    this.metaDataService.updateCountry(country).subscribe((res: any) => {
      var data: any;
      data = res;
      if (data.isActive) {
        this.messageService.showSuccess("Country Enabled successfully")
      } else {
        this.messageService.showSuccess("Country Disabled successfully")
      }

    });
  }

}
