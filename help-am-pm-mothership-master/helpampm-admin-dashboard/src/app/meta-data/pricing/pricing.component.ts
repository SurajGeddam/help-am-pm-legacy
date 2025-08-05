import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { NgbModal, NgbModalOptions } from '@ng-bootstrap/ng-bootstrap';
import { DatatableComponent } from '@swimlane/ngx-datatable';
import { FilterService } from 'src/app/core/service/filter.service';
import { MessageService } from 'src/app/core/service/message.service';
import { StorageService } from 'src/app/core/service/storage.service';
import { MetaDataService } from '../meta-data.service';

@Component({
  selector: 'app-pricing',
  templateUrl: './pricing.component.html',
  styleUrls: ['./pricing.component.sass']
})
export class PricingComponent implements OnInit {

  @ViewChild(DatatableComponent, { static: false }) table: DatatableComponent;
 
  rows = [];
  data = [];
  filteredData = [];
  editForm: FormGroup;
  isEdit: boolean = false;
 
  pricingId: number;
 
  constructor(
    private fb: FormBuilder,
    private modalService: NgbModal,
    private metaDataService: MetaDataService,
    private messageService: MessageService,
    private storageService: StorageService,
    private filterService: FilterService
  ) {
    this.editForm = this.fb.group({
      id: new FormControl(),
      description: ['', [Validators.required, Validators.minLength(3)]],
      name: ['', Validators.required]
    });
  }

  ngOnInit() {
    this.getData();
  }

  /**
   * @method getData
   * @Description get's All LPricing from the metadaService
   */
  getData() {
    this.metaDataService.getAllPricing().subscribe(
      (res: any) => {
        this.data = res;
        this.filteredData = this.data;
      }
    )
  }

  /**
   * @method edit
   * @param pricing 
   * @param content 
   * @param isEdit
   * @description open's the modal for the Edit and add Pricing
   */
  
   editPricing(pricing, content, isEdit) {
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
        id: pricing.id,
        description: pricing.description,
        name: pricing.name
      });
    }
  }
  openLeadPricing(content: any, data: any) {
    this.pricingId = data.id;
    const modaRef = this.modalService.open(content, {
      ariaLabelledBy: '',
      backdrop: false
    });

  }

  /**
   * @method updateObjectInList
   * @param object 
   * @description add the updated object on the top of the list of Pricing's
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

  removeSeconds(time: string){
    return time.slice(0,5);
  }
}
