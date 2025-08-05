import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { NgbModal, NgbModalOptions } from '@ng-bootstrap/ng-bootstrap';
import { DatatableComponent } from '@swimlane/ngx-datatable';
import { FilterService } from 'src/app/core/service/filter.service';
import { MessageService } from 'src/app/core/service/message.service';
import { StorageService } from 'src/app/core/service/storage.service';
import { MetaDataService } from '../meta-data.service';

@Component({
  selector: 'app-timeslot',
  templateUrl: './timeslot.component.html',
  styleUrls: ['./timeslot.component.scss']
})
export class TimeslotComponent implements OnInit {

  @ViewChild(DatatableComponent, { static: false }) table: DatatableComponent;
 // @ViewChild('openTime') openTime: NgxTimepickerFieldCompon;

  
  rows = [];
  data = [];
  filteredData = [];
  timeSlotForm: FormGroup;
  isEdit: boolean = false;
  startTime;
  categoryId: number;

  constructor(
    private fb: FormBuilder,
    private modalService: NgbModal,
    private metaDataService: MetaDataService,
    private messageService: MessageService,
    private storageService: StorageService,
    private filterService: FilterService
  ) {

    this.startTime=new FormControl();
    //this.editForm=new FormGroup()
    this.timeSlotForm = this.fb.group({
      id: new FormControl(),
      name: ['', [Validators.required]],
      startTime: ['', [Validators.required]],
      endTime: ['', Validators.required],
      isActive:[true]
    });
  }

  ngOnInit() {
    this.getData();
  }

  /**
   * @method getData
   * @Description get's All Timeslot from the metadaService
   */
  getData() {
    this.metaDataService.getAllTimeslot().subscribe(
      (res: any) => {
        this.data = res;
        this.filteredData = this.data;
      }
    )
  }

  /**
   * @method edit
   * @param timeslot 
   * @param content 
   * @param isEdit
   * @description open's the modal for the Edit and add Timeslot
   */
  addEditSlot(timeslot, content, isEdit) {
    //  this.editForm.reset();
    this.isEdit = isEdit;
    let ngbModalOptions: NgbModalOptions = {
      backdrop: 'static',
      keyboard: false,
      ariaLabelledBy: 'modal-basic-title'
    };
    this.modalService.open(content, ngbModalOptions);
    if (isEdit) {
      this.timeSlotForm.patchValue({
        id: timeslot.id,
        name: timeslot.name,
        startTime: new Date(timeslot.startTime),
        endTime: new Date(timeslot.endTime),
        isActive: timeslot.isActive,
      });
    }
  }
  opencategory(content: any, data: any) {
    this.categoryId = data.id;
    const modaRef = this.modalService.open(content, {
      ariaLabelledBy: '',
      backdrop: false
    });

  }

  /**
   * @method onEditSave
   * @param form 
   * @description Save's the edit and add Time slot Form
   */
  onEditSave(form: FormGroup) {
    const params  = form.value;
    
    params.startTime =new Date(params.startTime).toJSON().slice(11,19);
    params.endTime = new Date(params.endTime).toJSON().slice(11,19);
    if (form.valid && this.isEdit) {
      // Edit Form Submit
      this.metaDataService.updateCategory(params).subscribe((res: any) => {
        this.updateObjectInList(res);
        this.timeSlotForm.reset();
        this.modalService.dismissAll();
        this.messageService.showSuccess("Record Edited Successfully");
      }
      )
    } else if (form.valid && !this.isEdit) {
      // Add form Submit
      this.metaDataService.createTimeslot(params).subscribe(
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
   * @description add the updated object on the top of the list of Timeslot's
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
    let category = row;

    this.metaDataService.updateTimeslotStatus(row.id,event.checked).subscribe((res: any) => {
      var data: any;
      data = res;
      if (data.isActive) {
        this.messageService.showSuccess("Timeslot " + data.name + " Enabled successfully")
      } else {
        this.messageService.showSuccess("Timeslot " + data.name + "  Disabled successfully")
      }

    });
  }

}
