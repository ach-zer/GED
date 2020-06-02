import { TestBed } from '@angular/core/testing';

import { DocCaraService } from './doc-cara.service';

describe('DocCaraService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DocCaraService = TestBed.get(DocCaraService);
    expect(service).toBeTruthy();
  });
});
