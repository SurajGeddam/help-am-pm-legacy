import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { NgbModal, NgbModalOptions } from '@ng-bootstrap/ng-bootstrap';
import { DatatableComponent } from '@swimlane/ngx-datatable';
import { FilterService } from 'src/app/core/service/filter.service';
import { MessageService } from 'src/app/core/service/message.service';
import { StorageService } from 'src/app/core/service/storage.service';
import { MetaDataService } from '../meta-data.service';

@Component({
  selector: 'app-info',
  templateUrl: './help.component.html',
  styleUrls: ['./help.component.sass']
})
export class HelpComponent implements OnInit {

  @ViewChild(DatatableComponent, { static: false }) table: DatatableComponent;

  helpRows = [];
  helpData = [];
  data = [];
  helpFilteredData = [];
  helpForm: FormGroup;
  isEdit: boolean = false;
  isSubmitted: boolean = false;

  constructor(
    private fb: FormBuilder,
    private modalService: NgbModal,
    private metaDataService: MetaDataService,
    private messageService: MessageService,
    private storageService: StorageService,
    private filterService: FilterService
  ) {


  }

  createHelpForm(p) {

    this.helpForm = this.fb.group({
      id: [p == null ? null : p.id],
      isActive: [p == null ? null : p.isActive],
      helpEmail: [p == null ? null : p.helpEmail, Validators.required],
      helpPhone: [p == null ? null : p.helpPhone, Validators.required],
      helpAlternatePhone: [p == null ? null : p.helpAlternatePhone],
    });

  }

  ngOnInit() {
    this.getData();
  }

  /**
   * @method getData
   * @Description get's All Lead Support Info from the metadaService
   */
  getData() {
    this.metaDataService.getAllSupportInfo().subscribe(
      (res: any) => {
        this.helpData = res;
        this.helpFilteredData = this.helpData;

      }
    )
  }

  /**
   * @method edit
   * @param helpInfo 
   * @param content 
   * @param isEdit
   * @description open's the modal for the Edit and add Help ifo
   */

  editHelp(helpInfo, content, isEdit) {
    this.createHelpForm(helpInfo);
    this.helpForm.reset();
    this.isEdit = isEdit;
    let ngbModalOptions: NgbModalOptions = {
      backdrop: 'static',
      keyboard: false,
      ariaLabelledBy: 'modal-basic-title'
    };
    this.modalService.open(content, ngbModalOptions);
    if (isEdit) {
      this.helpForm.setValue({
        id: helpInfo.id,
        helpEmail: helpInfo.helpEmail,
        helpPhone: helpInfo.helpPhone,
        isActive: helpInfo.isActive,
        helpAlternatePhone: helpInfo.helpAlternatePhone,
      });
    }
  }
 
  /**
   * @method onEditSave
   * @param form 
   * @description Save's the edit end add leadSoruce Form
   */
  onEditSave(form: FormGroup) {
    this.isSubmitted = true;

      if (form.valid && this.isEdit) {
         // Edit Form Submit
         this.metaDataService.updateHelpAndSuporr(form.value).subscribe((res: any) => {
           this.updateObjectInList(res);
           this.helpForm.reset();
           this.modalService.dismissAll();
           this.messageService.showSuccess("Record Edited Successfully");
         }
         )
       } else if (form.valid && !this.isEdit) {
         // Add form Submit
         this.metaDataService.createHelpAndSuporr(form.value).subscribe(
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
   * @description add the updated object on the top of the list of Help
   */
  updateObjectInList(object) {
    const data = this.helpData.filter(ele => ele.id != object.id);
    data.unshift(object);
    this.helpData = [...data];
  }

  /**
   * @method filterDatatable
   * @param event 
   * @description search for the filter data table
   */
  filterDatatable(event) {
    this.helpData = this.filterService.filter(event, this.helpFilteredData, this.helpData);
    this.table.offset = 0;
  }

  changeStatus(event, row) {
    let helpSupport = row;
    helpSupport.isActive = event.checked;

    this.metaDataService.updateHelpAndSuporr(helpSupport).subscribe((res: any) => {
      var data: any;
      data = res;
      if (data.isActive) {
        this.messageService.showSuccess(" Enabled successfully")
      } else {
        this.messageService.showSuccess(" Disabled successfully")
      }

    });
  }
}

