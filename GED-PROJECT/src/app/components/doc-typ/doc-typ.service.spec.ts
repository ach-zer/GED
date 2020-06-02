import { TestBed } from '@angular/core/testing';

import { DocTypService } from './doc-typ.service';

describe('DocTypService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DocTypService = TestBed.get(DocTypService);
    expect(service).toBeTruthy();
  });
});
