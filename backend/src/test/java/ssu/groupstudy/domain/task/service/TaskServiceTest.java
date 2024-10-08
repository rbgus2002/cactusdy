package ssu.groupstudy.domain.task.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.round.exception.InvalidRoundParticipantException;
import ssu.groupstudy.domain.round.exception.RoundNotFoundException;
import ssu.groupstudy.domain.round.exception.RoundParticipantNotFoundException;
import ssu.groupstudy.domain.round.repository.RoundParticipantEntityRepository;
import ssu.groupstudy.domain.round.repository.RoundEntityRepository;
import ssu.groupstudy.api.task.vo.CreatePersonalTaskReqVo;
import ssu.groupstudy.api.task.vo.UpdateTaskReqVo;
import ssu.groupstudy.domain.task.exception.TaskNotFoundException;
import ssu.groupstudy.domain.task.repository.TaskEntityRepository;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;
import static ssu.groupstudy.domain.common.enums.ResultCode.*;

class TaskServiceTest extends ServiceTest {
    @InjectMocks
    private TaskService taskService;
    @Mock
    private UserEntityRepository userEntityRepository;
    @Mock
    private RoundEntityRepository roundEntityRepository;
    @Mock
    private TaskEntityRepository taskEntityRepository;
    @Mock
    private RoundParticipantEntityRepository roundParticipantEntityRepository;

    @Nested
    class DeleteTask{
        @Test
        @DisplayName("태스크가 존재하지 않는 경우 예외를 던진다.")
        void TaskNotFound(){
            // given, when
            doReturn(Optional.empty()).when(taskEntityRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> taskService.deleteTask(-1L, -1L))
                    .isInstanceOf(TaskNotFoundException.class)
                    .hasMessage(TASK_NOT_FOUND.getMessage());
        }
        
        @Test
        @DisplayName("회차 참여자가 존재하지 않는 경우 예외를 던진다")
        void RoundParticipantNotFound(){
            // given, when
            doReturn(Optional.of(개인태스크)).when(taskEntityRepository).findById(any(Long.class));
            doReturn(Optional.empty()).when(roundParticipantEntityRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> taskService.deleteTask(-1L, -1L))
                    .isInstanceOf(RoundParticipantNotFoundException.class)
                    .hasMessage(ROUND_PARTICIPANT_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("본인의 태스크가 아니라면 예외를 던진다")
        void invalidDeleteTask(){
            // given, when
            doReturn(Optional.of(개인태스크)).when(taskEntityRepository).findById(any(Long.class));
            doReturn(Optional.of(회차1_장재우)).when(roundParticipantEntityRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> taskService.deleteTask(-1L, -1L))
                    .isInstanceOf(InvalidRoundParticipantException.class)
                    .hasMessage(INVALID_TASK_ACCESS.getMessage());
        }
    }

    @Nested
    class GetTasks{
        @Test
        @DisplayName("회차가 존재하지 않는 경우 예외를 던진다")
        void roundNotFound(){
            // given, when
            doReturn(Optional.empty()).when(roundEntityRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> taskService.getTasks(-1L, 최규현))
                    .isInstanceOf(RoundNotFoundException.class)
                    .hasMessage(ROUND_NOT_FOUND.getMessage());
        }
    }

    @Nested
    class CreatePersonalTask{
        final CreatePersonalTaskReqVo request = CreatePersonalTaskReqVo.builder()
                .roundParticipantId(-1L)
                .detail("개인 태스크")
                .build();

        @Test
        @DisplayName("회차 참여자가 존재하지 않는 경우 예외를 던진다")
        void roundParticipantNotFound(){
            // given
            // when
            doReturn(Optional.empty()).when(roundParticipantEntityRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> taskService.createPersonalTask(request))
                    .isInstanceOf(RoundParticipantNotFoundException.class)
                    .hasMessage(ROUND_PARTICIPANT_NOT_FOUND.getMessage());
        }
    }

    @Nested
    class updateTaskDetail{
        UpdateTaskReqVo request = UpdateTaskReqVo.builder()
                .taskId(-1L)
                .detail("수정내용")
                .build();

        @Test
        @DisplayName("태스크가 존재하지 않는 경우 예외를 던진다.")
        void TaskNotFound(){
            // given, when
            doReturn(Optional.empty()).when(taskEntityRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> taskService.updateTaskDetail(request))
                    .isInstanceOf(TaskNotFoundException.class)
                    .hasMessage(TASK_NOT_FOUND.getMessage());
        }
    }

    @Nested
    class switchTask{
        @Test
        @DisplayName("태스크가 존재하지 않는 경우 예외를 던진다.")
        void TaskNotFound(){
            // given, when
            doReturn(Optional.empty()).when(taskEntityRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> taskService.switchTask(-1L, 최규현))
                    .isInstanceOf(TaskNotFoundException.class)
                    .hasMessage(TASK_NOT_FOUND.getMessage());
        }
    }
}