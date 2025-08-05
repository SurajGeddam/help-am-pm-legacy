package com.helpampm.metadata.staticContent;

import java.util.List;

public interface StaticContentService {

    StaticContent create( StaticContent content);

    StaticContent update( StaticContent content);

    List<StaticContent> getAll();

    StaticContent getById(Integer id);
}
