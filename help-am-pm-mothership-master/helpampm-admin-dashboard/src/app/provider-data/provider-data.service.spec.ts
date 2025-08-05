import { TestBed } from '@angular/core/testing';

import { ProviderDataService } from './provider-data.service';

describe('ProviderDataService', () => {
  let service: ProviderDataService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ProviderDataService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
