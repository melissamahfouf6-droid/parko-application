import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('loyalty_accounts')
export class LoyaltyAccount {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ unique: true })
  userId!: string;

  /** Redeemable points (earnings minus redemptions). */
  @Column({ type: 'int', default: 0 })
  balancePoints!: number;

  /** Lifetime points earned (drives tier: Bronze → Platinum). */
  @Column({ type: 'int', default: 0 })
  lifetimeEarned!: number;

  @Column({ default: 'bronze' })
  level!: string;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
