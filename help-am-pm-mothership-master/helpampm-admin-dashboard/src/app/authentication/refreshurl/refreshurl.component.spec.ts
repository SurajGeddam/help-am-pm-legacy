import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RefreshurlComponent } from './refreshurl.component';

describe('RefreshurlComponent', () => {
  let component: RefreshurlComponent;
  let fixture: ComponentFixture<RefreshurlComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RefreshurlComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(RefreshurlComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
