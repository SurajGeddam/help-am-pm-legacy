import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { MessageService } from 'src/app/core/service/message.service';
import { MetaDataService } from '../../meta-data.service';

export interface Category {
  commercialService : boolean,
  createdAt: string,
  description: string,
  icon: string,
  id: number, 
  isActive: boolean,
  lastUpdatedAt: string,
  name: string,
  residentialService: boolean,
  timeslots: TimeSlot
}

export interface TimeSlot{
  id: number,
  name: string,
  startTime: string, 
  endTime: string,
  isActive : boolean,
  pricing: number,
  categoryId: number, 
  createdAt: string, 
  lastUpdatedAt: string
}

export interface Price {
  id: number,
  type: string,
  residentialPrice: number,
  commercialPrice: number,
  isActive: boolean,
  currency: string,
  createdAt: string, 
  lastUpdatedAt: string
}

@Component({
  selector: 'app-category-detail',
  templateUrl: './category-detail.component.html',
  styleUrls: ['./category-detail.component.scss']
})
export class CategoryDetailComponent implements OnInit {

  id!: number;
  category!: Category;
  editForm: FormGroup;
  isEdit: boolean;
  timeSlotForm: FormGroup;
  pricingType : {id: string, name: string}[] = [
    {id: 'HOURLY', name: 'Hourly'},
    {id: 'FIXED', name: 'Fixed'}
  ]
  currency: {id: string, name: string}[] = [
    {id: 'DOLLAR', name: 'Dollar'},
    {id: 'GBP', name: 'Sterling Pound'},
    {id: 'INR', name: 'Indian Rupee'}
  ]
   modaRef ;
  
  constructor(
    private route: ActivatedRoute,
    private metaService: MetaDataService,
    private fb: FormBuilder,
    private messageService: MessageService,
    private modalService: NgbModal
    ) { 
    this.editForm = this.fb.group({
      id: [],
      description: ['', [Validators.required, Validators.minLength(3)]],
      name: ['', Validators.required],
      commercialService: ['', Validators.required],
      residentialService: ['', Validators.required]
    });
    this.timeSlotForm = this.fb.group({
      id: [],
      name: [], 
      startTime: [], 
      categoryId: [],
      endTime: [],
      pricing : this.fb.group({
        id: [],
        type: [],
        currency: [],
        residentialPrice: [],
        commercialPrice: []
      })
    })
  }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      this.id = params['id'];
    });
    this.getCategoryDataById();  
  }

  getCategoryDataById(){
    this.metaService.getCategoryById(this.id).subscribe({
      next: (res) => {
        this.category = res;
        this.editForm.patchValue(this.category);
      }
    })
  }

   /**
   * @method onEditSave
   * @param form 
   * @description Save's the edit end add leadSoruce Form
   */
   onEditSave(form: FormGroup) {
    this.metaService.updateCategory(form.value).subscribe((res: any) => {
      this.messageService.showSuccess("Record Edited Successfully");
    })
  }

  openAddEditModal(modalId, data, isEdit){
    this.timeSlotForm.reset();
    this.isEdit = isEdit;
    this.modaRef = this.modalService.open(modalId, {
      ariaLabelledBy: '',
      backdrop: false,
      size: 'lg'
    });
    if(isEdit){
      this.timeSlotForm.patchValue(data);
    }
  }

  onTimeSlotSave(form: FormGroup){
    let param = form.value;
    param.categoryId = this.id;
    // param.startTime = this.chageNumberToTime(param.startTime);
    // param.endTime = this.chageNumberToTime(param.endTime);
    let timeslotId=param.id;
    let pricing=param.pricing;
    console.log(this.category); 
    this.metaService.updatePricing(timeslotId,pricing).subscribe({
      next : (res) => {
        this.messageService.showSuccess("Records saved Successfully");
        this.modaRef.close();
        this.getCategoryDataById();  

      }
    })
  }

  getIcon(row) {
    if (row) {
      return "check_circle"
    } else {
      return "cancel"
    }
  }
  getIconColor(row) {
    if (row) {
      return "green"
    } else {
      return "red"
    }
  }

  // chageNumberToTime(num){
  //   return num.substring(0,2) + ':' + num.substring(2,4) + ":00";
  // }

}
