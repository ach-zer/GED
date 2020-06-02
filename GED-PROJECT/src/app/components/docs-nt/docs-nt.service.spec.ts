import { TestBed } from '@angular/core/testing';

import { DocsNtService } from './docs-nt.service';

describe('DocsNtService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DocsNtService = TestBed.get(DocsNtService);
    expect(service).toBeTruthy();
  });
});
