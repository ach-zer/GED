import { TestBed } from '@angular/core/testing';

import { AnnotationsDocService } from './annotations-doc.service';

describe('AnnotationsDocService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: AnnotationsDocService = TestBed.get(AnnotationsDocService);
    expect(service).toBeTruthy();
  });
});
