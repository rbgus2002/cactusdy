package ssu.groupstudy.domain.common;

import com.google.gson.Gson;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.MockMvc;

@ExtendWith(MockitoExtension.class)
public class ApiTest {
    protected MockMvc mockMvc;
    protected Gson gson;

    @BeforeEach
    void initGson(){
        gson = new Gson();
    }
}
