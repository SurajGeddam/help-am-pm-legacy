import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';

import { ComponentsModule } from './components/components.module';
import { FeatherIconsModule } from './feather-icons.module';
import { MaterialModule } from './material.module';
import {DateAgoPipe} from './directives/DateAgoPipe'
import {DateDifference} from './directives/DateDifference'


@NgModule({
  declarations: [
    DateAgoPipe,
    DateDifference
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    RouterModule,
    NgbModule,
    FeatherIconsModule,
    ComponentsModule,
  ],
  exports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    RouterModule,
    NgbModule,
    MaterialModule,
    FeatherIconsModule,
    ComponentsModule,
    DateAgoPipe,
    DateDifference
  ]
})
export class SharedModule {}
