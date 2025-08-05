import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { NgbModal, NgbModalOptions } from '@ng-bootstrap/ng-bootstrap';
import { DatatableComponent } from '@swimlane/ngx-datatable';
import { FilterService } from 'src/app/core/service/filter.service';
import { MessageService } from 'src/app/core/service/message.service';
import { MetaDataService } from '../meta-data.service';

@Component({
  selector: 'app-faq',
  templateUrl: './faq.component.html',
  styleUrls: ['./faq.component.scss']
})
export class FaqComponent implements OnInit {

  @ViewChild(DatatableComponent, { static: false }) table: DatatableComponent;

  rows = [];
  data = [];
  filteredData = [];

  editForm: FormGroup;
  isEdit: boolean = false;

  faqId: number;

  constructor(
    private fb: FormBuilder,
    private modalService: NgbModal,
    private metaDataService: MetaDataService,
    private messageService: MessageService,
    private filterService: FilterService
  ) {
    this.editForm = this.fb.group({
      id: new FormControl(),
      question: ['', Validators.required],
      answer: ['', Validators.required],
      langCode: ['', Validators.required],
      createdAt: ['']
    });
  }

  ngOnInit() {
    this.getData();
  }

  /**
   * @method getData
   * @Description get's All Faqes from the metadaService
   */
  getData() {
    this.metaDataService.getAllFaq().subscribe(
      (res: any) => {
        this.data = res;
        this.filteredData = this.data;
      }
    )
  }

  /**
   * @method edit
   * @param faq 
   * @param content 
   * @param isEdit
   * @description open's the modal for the Edit and add Faq
   */

  editFaq(faq, content, isEdit) {
    this.editForm.reset();
    this.editForm.controls.langCode.setValue('en')
    this.isEdit = isEdit;
    let ngbModalOptions: NgbModalOptions = {
      backdrop: 'static',
      keyboard: false,
      ariaLabelledBy: 'modal-basic-title'
    };
    this.modalService.open(content, ngbModalOptions);
    if (isEdit) {
      this.editForm.setValue({
        id: faq.id,
        question: faq.question,
        answer: faq.answer,
        langCode: faq.langCode,
        createdAt: faq.createdAt,
        isActive: faq.isActive
      });
    }
  }
  openDeleteFaq(content: any, data: any) {
    this.faqId = data.id;
    const modaRef = this.modalService.open(content, {
      ariaLabelledBy: '',
      backdrop: false
    });
  }

  deleteFaq() {
    this.metaDataService.deleteFaq(this.faqId).subscribe((res: any) => {
      this.getData();
      this.messageService.showSuccess(res.message);
      this.modalService.dismissAll();
    });
  }

  /**
   * @method onEditSave
   * @param form 
   * @description Save's the edit end add Faq Form
   */
  onEditSave(form: FormGroup) {
    if (form.valid && this.isEdit) {
      // Edit Form Submit
      this.metaDataService.updateFaq(form.value).subscribe((res: any) => {
        this.updateObjectInList(res);
        this.editForm.reset();
        this.modalService.dismissAll();
        this.messageService.showSuccess("Record Edited Successfully");
      })
    } else if (form.valid && !this.isEdit) {
      form.value['isActive'] = true;
      // Add form Submit
      this.metaDataService.createFaq(form.value).subscribe(
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
   * @description add the updated object on the top of the list of Faq's
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
    let faq = row;
    faq = {
      id: row.id,
      isActive: event.checked
    }

    this.metaDataService.updateFaq(faq).subscribe((res: any) => {
      var data: any;
      data = res;
      if (data.isActive) {
        this.messageService.showSuccess("Faq " + data.name + " Enabled successfully")
      } else {
        this.messageService.showSuccess("Faq " + data.name + "  Disabled successfully")
      }

    });
  }

}
