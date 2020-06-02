import { TestBed } from '@angular/core/testing';

import { DocsAllService } from './docs-all.service';

describe('DocsAllService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DocsAllService = TestBed.get(DocsAllService);
    expect(service).toBeTruthy();
  });
});
