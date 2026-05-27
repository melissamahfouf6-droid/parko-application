import {
  Column,
  CreateDateColumn,
  Entity,
  Index,
  PrimaryGeneratedColumn,
} from 'typeorm';

@Entity('buddy_messages')
export class BuddyMessage {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  /** Buddy seeker row id — conversation thread. */
  @Index()
  @Column({ type: 'varchar' })
  threadId!: string;

  @Column({ type: 'varchar' })
  senderUserId!: string;

  @Column({ type: 'text' })
  text!: string;

  @CreateDateColumn()
  createdAt!: Date;
}
